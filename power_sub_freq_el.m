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


Power_analysis = struct();
Power_analysis.subj = [];
Power_analysis.role = [];
Power_analysis.cond = [];
Power_analysis.power = [];


% loop over recordings
for i = 1:numel(list_of_files)
    % load next file
    EEG = pop_loadset('filename', list_of_files(i).name);
    
    % get and save subject information
    [subj, role, cond] = subjectinfo(EEG.setname);
    Power_analysis(i).subj = subj;
    Power_analysis(i).role = role;
    Power_analysis(i).cond = cond;
    
    % calculate power for each channel and frequency
    power = zeros(EEG.nbchan,nfreqs);
    for ch = 1:EEG.nbchan
        [spectra, freqs] = spectopo(EEG.data(ch,:,:),0,EEG.srate);
        % only take the specified n freqs
        spectra = spectra(1:nfreqs);
        freqs = freqs(1:nfreqs);
        % transform to absolute power element wise
        power(ch,:) = 10.^(spectra/10);
    end
    
    % save power/freq matrix in struct
    Power_analysis(i).power = power;
end



% figure();
% imagesc(Power_analysis(4).power);
% colorbar;
% title(strcat('Subj-', subj,' Role-', role,' Condition-', cond));
