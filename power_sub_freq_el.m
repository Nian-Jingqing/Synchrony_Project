%% creates struct with power(over time) channel-frequency-matrix 
% for each subject/role/condition
%% Load data
if strcmp(getenv('USER'),'til')
    cd /Users/til/Uni/Master/_Ma.Thesis
    addpath(genpath('/Users/til/Uni/Master/_Ma.Thesis'))
else
    cd D:\Dropbox\Projects\Emotional_Sharing_EEG
    addpath(genpath('D:\Dropbox\Projects\Emotional_Sharing_EEG'))
end

eeglabpath = fileparts(which('eeglab.m'));
% load eeglab
eeglab; close;

% navigate to data
if strcmp(getenv('USER'),'til')
    cd /Users/til/Uni/Master/_Ma.Thesis/project_data/preprocessed_july/hyper_cleaned
else
    cd D:\Dropbox\Projects\Emotional_Sharing_EEG\EEG_Data\Preprocessed_July\hyper_cleaned
    
end

% get list of all files
list_of_files = dir('**/*.set');

%% Poweranalysis  

% how many freqs to analyse
nfreqs = 45;

% create struct and fields
Power_mat = struct();
Power_mat.subj = [];
Power_mat.role = [];
Power_mat.cond = [];
Power_mat.power = [];


% loop over recordings
for i = 1:numel(list_of_files)
    % load next file
    EEG = pop_loadset('filename', list_of_files(i).name);
    
    % get and save subject information
    [subj, role, cond] = subjectinfo(EEG.setname);
    Power_mat(i).subj = subj;
    Power_mat(i).role = role;
    Power_mat(i).cond = cond;
    
    % calculate power for each channel and frequency
    power = zeros(EEG.nbchan,nfreqs);
    for ch = 1:EEG.nbchan
        [spectra, freqs] = spectopo(EEG.data(ch,:,:),0,EEG.srate,'freqrange',[0 nfreqs],'plot','off','verbose','off');
        % only take the specified n freqs
        spectra = spectra(1:nfreqs);
        freqs = freqs(1:nfreqs);
        % transform to absolute power element wise
        power(ch,:) = 10.^(spectra/10);
    end
    
    % save power/freq matrix in struct
    Power_mat(i).power = power;
    disp(i/numel(list_of_files));
end


%% Plotting over subjects

% list all uniqe subjects
unique_subj = unique({Power_mat.subj});

% loop over unique subjects
for subjidx = 1:numel(unique_subj)
    
    % set plot dimensions
    x0=10;
    y0=500;
    width=2000;
    height=250;

    % Collect all matrices belonging to current subj.
    Current_subj = Power_mat(strcmp({Power_mat.subj}, string(unique_subj(subjidx))));
    % sort by conditions RS1, NS, RS2, ES, RS3
    Sorted_subj = [Current_subj(strcmp({Current_subj.cond},'RS1'));...
       Current_subj(strcmp({Current_subj.cond},'NS'));...
       Current_subj(strcmp({Current_subj.cond},'RS2'));...
       Current_subj(strcmp({Current_subj.cond},'ES'));...
       Current_subj(strcmp({Current_subj.cond},'RS3'))];
    
    % plot
    figure();
    for i = 1:numel(Sorted_subj)
        subplot(1,5,i);
        imagesc(Sorted_subj(i).power);
        title(strcat('Subj-', Sorted_subj(i).subj,' Role-', Sorted_subj(i).role,' Condition-', Sorted_subj(i).cond));
        colorbar;
    end
    set(gcf,'position',[x0,y0,width,height])
end
    
  
%% TODO 
% save plots 
