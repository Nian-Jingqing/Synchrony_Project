%% Load data
cd D:\Dropbox\Synchrony_Adam
addpath(genpath('D:\Dropbox\Synchrony_Adam'))
eeglabpath = fileparts(which('eeglab.m'));
% load eeglab
eeglab;

% load xdf file with both datasets + video frames
d = load_xdf('SNS_015L_016S_N_NS.xdf');
%load first subject into eeglab template
eeg_sub1 = pop_loadxdf('SNS_015L_016S_N_NS.xdf');
% copy the eeglab template for the sub2 and replace sub1 data with sub2
% data
eeg_sub2 = eeg_sub1;
eeg_sub2.data = d{1,4}.time_series;
eeg_sub2.times = round(linspace(0,fix(d{1,4}.segments.duration *1000),d{1,4}.segments.num_samples));
eeg_sub2.pnts = d{1,4}.segments.num_samples;
eeg_sub2.xmax = eeg_sub2.times(end)/1000;

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
    EEG.filename = EEG.filename(1:end-4);
    
    % HIGH- AND LOW-PASS FILTERING
    EEG = pop_eegfiltnew(EEG, high_pass, []); % 0.1 is the lower edge
    EEG = pop_eegfiltnew(EEG, [], low_pass); % 100 is the upper edge
    % remove line noise with zapline
    d_tmp = permute(EEG.data, [2,1]);
    d_tmp = nt_zapline(d_tmp, power_line/srate);
    EEG.data = permute(d_tmp,[2,1]);
    
    EEG = pop_chanedit(EEG, 'lookup',fullfile(eeglabpath,'plugins/dipfit/standard_BESA/standard-10-5-cap385.elp'));
    full_chanlocs = EEG.chanlocs;
    % plot continuous data
    %eegplot(eeg_sub1.data,'srate',eeg_sub1.srate,'eloc_file',eeg_sub1.chanlocs)
    
    % automatic channel rejection
    [EEG indelec] = pop_rejchan(EEG, 'elec',[1:24] ,'threshold',3,'norm','on','measure','kurt');
    % save labels of removed channels
    
    % ASR
    EEG = clean_artifacts(EEG);
    % ADD removed channels from this dataset to other removed channels to keep
    % track
    
    %removed_electrodes = {eeg_sub1.chanlocs(indelec).labels};
    
    
    
    % high pass 2 Hz for data used for ICA calculations
    eeg_tmp = pop_eegfiltnew(EEG, 2, []);   % highpass  2 Hz to not include slow drifts
    % create amica folder
    cd D:\Dropbox\Synchrony_Adam\EEG_Data\Preprocessed
    mkdir(sprintf('amica_%s_%d',EEG.filename, sub))
    outDir = what(sprintf('amica_%s_%d',EEG.filename,sub));
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
    
    %eegplot(eeg_sub1.data,'srate',eeg_sub1.srate,'eloc_file',eeg_sub1.chanlocs)
    
    EEG = clean_artifacts(EEG);
    
    EEG = pop_interp(EEG, full_chanlocs,'spherical');
    
    EEG = pop_editset(EEG, 'setname', sprintf('cleaned_%s_sub_%d', EEG.filename, sub));
    EEG = pop_saveset(EEG, 'filename', sprintf('cleaned_%s_sub_%d', EEG.filename, sub));
end
    
    
    
    
    
    
    
    
    
    
    
    