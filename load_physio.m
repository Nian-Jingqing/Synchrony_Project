%% Load data
cd D:\Dropbox\Synchrony_Adam
addpath(genpath('D:\Dropbox\Synchrony_Adam'))

% samplig rate is 1000 Hz, 
%column 1 == time (ms) 
%column 2 == raw signal ECG
d = importdata('SNS_005_11061518_ECG.txt')
%%