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
eeglab;

if strcmp(getenv('USER'),'til')
    cd /Users/til/Uni/Master/_Ma.Thesis/project_data/preprocessed_july/hyper_cleaned
else
    cd D:\Dropbox\Projects\Emotional_Sharing_EEG\EEG_Data\Preprocessed_July\hyper_cleaned
end
list_of_files = dir('**/*.set');



EEG = pop_loadset('filename', list_of_files(1).name);
