%% Load Data
% check system to get correct filepath
if strcmp(getenv('USER'),'til')
    filepath = '/Volumes/Tils Passport/Uni/MasterthesisData/pow_corr_single';
else
    filepath = '';
end

filepath = '/Users/til/Uni/Master/_Ma.Thesis/analysis_data';
cd(filepath);
addpath(genpath(filepath))



AllFiles = dir('*.mat');
for k = 1:numel(S)
    F = dir(fullfile(filepath,S(k).name));
    S(k).data = readmatrix(F); % much better than EVAL and LOAD.
end


test = load(AllFiles(3).name);
tests = test.tf_elec;