%% Load data
cd D:\Dropbox\Synchrony_Adam
addpath(genpath('D:\Dropbox\Synchrony_Adam'))

% samplig rate is 1000 Hz, 
%column 1 == time (ms) 
%column 2 == raw signals 

%ECG
ECG_sub_1 = importdata('SNS_013L_N_11161318_ECG.txt');
ECG_sub_2 = importdata('SNS_014S_N_11161318_ECG.txt');

%PCG
PCG_sub_1 = importdata('SNS_013L_N_11161318_PCG.txt');
PCG_sub_2 = importdata('SNS_014S_N_11161318_PCG.txt');
%% Manual selection of condition
% plot data and detect peaks to select data points
%plot(PCG_sub_1.data(:,1),PCG_sub_1.data(:,2))

% 558100  start resting state 1
% 858000  end resting state 1
% 889600  start neutral
% 1189000 end neutral
% 1390000 start resting state 2
% 1690000 end resting state 2
% 1719000 start emotional
% 2019000 end emotional

ECG_sub_1_RS1 = ECG_sub_1.data(558100:858000,1:2);
ECG_sub_2_RS1 = ECG_sub_2.data(558100:858000,1:2);

ECG_sub_1_N = ECG_sub_1.data(889600:1189000,1:2);
ECG_sub_2_N = ECG_sub_2.data(889600:1189000,1:2);

ECG_sub_1_RS2 = ECG_sub_1.data(1390000:1690000,1:2);
ECG_sub_2_RS2 = ECG_sub_2.data(1390000:1690000,1:2);

ECG_sub_1_E = ECG_sub_1.data(1719000:2019000,1:2);
ECG_sub_2_E = ECG_sub_2.data(1719000:2019000,1:2);

%% correlation

RS1_cor = corr(ECG_sub_1_RS1(:,2), ECG_sub_2_RS1(:,2));
RS2_cor = corr(ECG_sub_1_RS2(:,2), ECG_sub_2_RS2(:,2));

E_cor = corr(ECG_sub_1_E(:,2), ECG_sub_2_E(:,2));
N_cor = corr(ECG_sub_1_N(:,2), ECG_sub_2_N(:,2));


%% cross-correlation

time_window = 1000; % ms
window_lag = 1;

[RS_1.C,RS_1.L,RS_1.T] = corrgram(ECG_sub_1_RS1(:,2), ECG_sub_2_RS1(:,2),window_lag,time_window);

[RS_2.C,RS_2.L,RS_2.T] = corrgram(ECG_sub_1_RS2(:,2), ECG_sub_2_RS2(:,2),window_lag,time_window);

[E.C,E.L,E.T] = corrgram(ECG_sub_1_E(:,2), ECG_sub_2_E(:,2),window_lag,time_window);
[N.C,N.L,N.T] = corrgram(ECG_sub_1_N(:,2), ECG_sub_2_N(:,2),window_lag,time_window);

figure(1)
plot (E.C(2,:))
hold on
plot (N.C(2,:))
plot (RS_1.C(2,:))
plot (RS_2.C(2,:))
legend('emotional', 'neutral', 'resting state 1', 'resting state 2')
%%

