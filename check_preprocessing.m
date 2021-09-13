%% Load data
cd D:\Dropbox\Projects\Emotional_Sharing_EEG
addpath(genpath('D:\Dropbox\Projects\Emotional_Sharing_EEG'))
eeglabpath = fileparts(which('eeglab.m'));
% load eeglab
eeglab;

cd D:\Dropbox\Projects\Emotional_Sharing_EEG\EEG_Data\Preprocessed_July\hyper_cleaned
list_of_files = dir('**/*.set');

EEG = pop_loadset('filename', list_of_files(1).name,'check', 'off', 'loadmode', 'info');
