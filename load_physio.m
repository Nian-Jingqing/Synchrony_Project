%% Load data
cd D:\Dropbox\Synchrony_Adam
addpath(genpath('D:\Dropbox\Synchrony_Adam'))

% samplig rate is 1000 Hz, 
%column 1 == time (ms) 
%column 2 == raw signal ECG
d_sub_1 = importdata('SNS_013L_N_11161318_ECG.txt');
d_sub_2 = importdata('SNS_014S_N_11161318_ECG.txt');
%%



%%