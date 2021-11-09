%% Load data
cd D:\Dropbox\Projects\Emotional_Sharing_EEG
addpath(genpath('D:\Dropbox\Projects\Emotional_Sharing_EEG'))
eeglabpath = fileparts(which('eeglab.m'));
% load eeglab
eeglab;


cd D:\Dropbox\Projects\Emotional_Sharing_EEG\EEG_Data\LSL_September
list_of_files = dir('**/*.xdf');





for eeg_file = 81:size(list_of_files)

    path_to_file = [list_of_files(eeg_file).folder '\' list_of_files(eeg_file).name];
    path_new_folder = sprintf('D:\\Dropbox\\Projects\\Emotional_Sharing_EEG\\EEG_Data\\LSL_September\\%s_MOBI', list_of_files(eeg_file).name);

    mobilab.allStreams = dataSourceXDF(path_to_file, path_new_folder);
    all_mobilab_streams = [mobilab.allStreams().item];
    
    eeg_streams = [];
    for stream = 1:(size(all_mobilab_streams,2))
        if (size(all_mobilab_streams{stream}.data,1) > 100000)
            eeg_streams =  [eeg_streams stream];
        end
    end
   
    

    exported_EEG = mobilab.allStreams().export2eeglab(eeg_streams);
    exported_EEG.data(:, any(isnan(exported_EEG.data),1)) = [];
    exported_EEG.pnts = size(exported_EEG.data,2);
    exported_EEG.times = exported_EEG.times(1:size(exported_EEG.data,2));
    
    
    eeg_sub1 = pop_select(exported_EEG, 'channel', {exported_EEG.chanlocs(1:24).labels});
    eeg_sub1.subject = exported_EEG.chanlocs(1).labels(1:20);
    
    
    eeg_sub2 = pop_select(exported_EEG, 'channel', {exported_EEG.chanlocs(25:48).labels});
    eeg_sub2.subject = exported_EEG.chanlocs(25).labels(1:20);

    
    



% add events to both datasets (300 events separated by 1 second
eeg_sub1_chanlocs = eeg_sub1.chanlocs;
eeg_sub1.data(25,[1000:500:500*floor(size(eeg_sub1.data,2)/500)]) = 1; % simulating a stimulus onset every second
eeg_sub1 = pop_chanevent(eeg_sub1, 25,'edge','leading','edgelen',0,'duration','on','nbtype',1);
eeg_sub1.chanlocs = eeg_sub1_chanlocs;

eeg_sub2_chanlocs = eeg_sub2.chanlocs;
eeg_sub2.data(25,[1000:500:500*floor(size(eeg_sub1.data,2)/500)]) = 1; % simulating a stimulus onset every second
eeg_sub2 = pop_chanevent(eeg_sub2, 25,'edge','leading','edgelen',0,'duration','on','nbtype',1);
eeg_sub2.chanlocs = eeg_sub2_chanlocs;

% parameters
low_pass = 100;
high_pass = .1;
srate = 500;
power_line = 50;

for sub = 1:2
    
    if sub == 1
        EEG = eeg_sub1;
    end
    if sub == 2
        EEG = eeg_sub2;
    end
    %file name
    %EEG.filename = EEG.filename(1:end-4);
    
    
    % HIGH- AND LOW-PASS FILTERING
    EEG = pop_eegfiltnew(EEG, high_pass, []); % 0.1 is the lower edge
    EEG = pop_eegfiltnew(EEG, [], low_pass); % 100 is the upper edge
    % remove line noise with zapline
    d_tmp = permute(EEG.data, [2,1]);
    d_tmp(isnan(d_tmp))=0;
    d_tmp = nt_zapline(d_tmp, power_line/srate);
    EEG.data = permute(d_tmp,[2,1]);
    
    EEG.setname = EEG.filepath(66:end);
    EEG.setname = EEG.setname(1:end-9);
    
    
    %
    
    for channel = 1:24
        tmp = strsplit(EEG.chanlocs(channel).labels,'_');
        EEG.chanlocs(channel).labels = char(tmp(end));
    end
   
    full_chanlocs = EEG.chanlocs;
    % plot continuous data
    %eegplot(eeg_sub1.data,'srate',eeg_sub1.srate,'eloc_file',eeg_sub1.chanlocs)
    
    % automatic channel rejection
    %[EEG indelec] = pop_rejchan(EEG, 'elec',[1:24] ,'threshold',3,'norm','on','measure','kurt');
    % save labels of removed channels
    
    count = 1;

    for event_id = 1:numel(EEG.event)
        if isequal(EEG.event(event_id).type, 'chan25')
            EEG.event(event_id).epoch_id = count;
            count = count + 1;
        else
            EEG.event(event_id).epoch_id = 0;
        end
        
    end
    
    
    % ASR
    EEG = clean_artifacts(EEG);

    % save removed channels
    removed_channels = ~ismember({full_chanlocs.labels},{EEG.chanlocs.labels});
    EEG.removed_channels = {full_chanlocs(removed_channels).labels};
    
    % high pass 2 Hz for data used for ICA calculations
    eeg_tmp = pop_eegfiltnew(EEG, 2, []);   % highpass  2 Hz to not include slow drifts
    % create amica folder
    cd D:\Dropbox\Projects\Emotional_Sharing_EEG\EEG_Data\Preprocessed_September
    mkdir(sprintf('ICA_amica_%s_%d',EEG.setname, sub))
    outDir = what(sprintf('ICA_amica_%s_%d',EEG.setname,sub));
    %run ICA
    dataRank = rank(double(eeg_tmp.data'));
    runamica15(eeg_tmp.data, 'num_chans', eeg_tmp.nbchan,...
        'outdir', outDir.path,...
        'pcakeep', dataRank, 'num_models', 1,...
        'do_reject', 1, 'numrej', 15, 'rejsig', 3, 'rejint', 1);
    
    %load ICA results
    mod = loadmodout15(outDir.path);
      
    %apply ICA weights to data
    EEG.icasphere = mod.S;
    EEG.icaweights = mod.W;
    EEG = eeg_checkset(EEG);
    
    % calculate iclabel classification
    EEG = iclabel(EEG);
    
    % list components that should be rejected
    components_to_remove = [];
    number_components = size(EEG.icaact,1);
    
    for component = 1:number_components
        % muscle
        if EEG.etc.ic_classification.ICLabel.classifications(component,2) > .80
            components_to_remove = [components_to_remove component];
        end
        % eye
        if EEG.etc.ic_classification.ICLabel.classifications(component,3) > .9
            components_to_remove = [components_to_remove component];
        end
        % heart
        if EEG.etc.ic_classification.ICLabel.classifications(component,4) > .9
            components_to_remove = [components_to_remove component];
        end
        % line noise
        if EEG.etc.ic_classification.ICLabel.classifications(component,5) > .9
            components_to_remove = [components_to_remove component];
        end
        % channel noise
        if EEG.etc.ic_classification.ICLabel.classifications(component,6) > .9
            components_to_remove = [components_to_remove component];
        end
    end
    
    % remove components
    EEG = pop_subcomp( EEG, components_to_remove, 0);
    % save removed components in struct
    EEG.removed_components = components_to_remove;
    
    % interpolate removed channels    
    EEG = pop_interp(EEG, full_chanlocs,'spherical');
    
    EEG = pop_editset(EEG, 'setname', sprintf('cleaned_%s_sub_%d', EEG.setname, sub));
    EEG = pop_saveset(EEG, 'filename', EEG.setname);
    if sub == 1
        eeg_sub1 = EEG;
    elseif sub == 2
        eeg_sub2 = EEG;
    end
end

%EPOCH %%%
window = [0 .999];
eeg_sub1 = pop_epoch( eeg_sub1, {'chan25'}, window, 'epochinfo', 'yes');
eeg_sub2 = pop_epoch( eeg_sub2, {'chan25'}, window, 'epochinfo', 'yes');

% finds trials that are present in both subjects
[val1 pos1] = intersect([eeg_sub1.event.epoch_id], [eeg_sub2.event.epoch_id]);
[val2 pos2] = intersect([eeg_sub2.event.epoch_id], [eeg_sub1.event.epoch_id]);

% remove trials that are not in both datasets
eeg_sub1.data = eeg_sub1.data(:,:,pos1);
eeg_sub1.event = eeg_sub1.event(pos1);
eeg_sub1.epoch = eeg_sub1.epoch(pos1);

eeg_sub2.data = eeg_sub2.data(:,:,pos2);
eeg_sub2.event = eeg_sub2.event(pos2);
eeg_sub2.epoch = eeg_sub2.epoch(pos2);

% create new latencies for concanated data
latency_sub1 = [];
count = -499;
for i = 1:size(eeg_sub1.event,2)
    count = count + 500;
    latency_sub1(i) = count; 
end
latency_sub2 = [];
count = -499;
for i = 1:size(eeg_sub2.event,2)
    count = count + 500;
    latency_sub2(i) = count; 
end

latency_sub1 = num2cell(latency_sub1');
latency_sub2 = num2cell(latency_sub2');

% concanate data
eeg_sub1.data = reshape(eeg_sub1.data, 24, []);
eeg_sub2.data = reshape(eeg_sub2.data, 24, []);

% add new latencies
[eeg_sub1.event.latency] = latency_sub1{:};
[eeg_sub2.event.latency] = latency_sub2{:};

eeg_sub1.trials = size(eeg_sub1.data,2)/500;
eeg_sub2.trials = size(eeg_sub2.data,2)/500;


% i commented out line 495 in the script 'po_editset': '%EEGOUT =
% eeg_checkset(EEGOUT);' because checkset was not allowing for manual
% concatation of data - change that if you run the script but remember to
% change it back afterwards.

% and line 132 in pop_saveset

eeg_sub1 = pop_editset(eeg_sub1, 'setname', sprintf('hyper_%s', eeg_sub1.setname));
eeg_sub1 = pop_saveset(eeg_sub1, 'filename', eeg_sub1.setname);
eeg_sub2 = pop_editset(eeg_sub2, 'setname', sprintf('hyper_%s', eeg_sub2.setname));
eeg_sub2 = pop_saveset(eeg_sub2, 'filename', eeg_sub2.setname);

    
end
    
    