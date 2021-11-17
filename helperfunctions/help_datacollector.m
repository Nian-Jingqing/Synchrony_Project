%% Helperscript to load data from respective folders
% create list of setfiles
if strcmp(getenv('USER'),'til')
    cd /Users/til/Uni/Master/_Ma.Thesis
    addpath(genpath('/Users/til/Uni/Master/_Ma.Thesis'))
else
    cd D:\Dropbox\Projects\Emotional_Sharing_EEG
    addpath(genpath('D:\Dropbox\Projects\Emotional_Sharing_EEG'))
end

% find eeglab
eeglabpath = fileparts(which('eeglab.m'));
% load eeglab
eeglab; close;

% navigate to data
if strcmp(getenv('USER'),'til')
    cd /Users/til/Uni/Master/_Ma.Thesis/project_data/preprocessed_july/hyper_cleaned
else
    cd D:\Dropbox\Projects\Emotional_Sharing_EEG\EEG_Data\Preprocessed_November\hyper_cleaned
    
end

% get list of all files
list_of_files = dir('**/*.set');