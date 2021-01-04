%% Load data
cd D:\Dropbox\Synchrony_Adam
addpath(genpath('D:\Dropbox\Synchrony_Adam'))

% samplig rate is 500 Hz, 
%column 1 == time (ms) 
%column 2 == raw signals 

%load ECG and PCG
%ECG_sub_1 = importdata('SNS_019L_E_11191310_ECG.txt'); % exported in 500 Hz

cd D:\Dropbox\Synchrony_Adam\Test_data\Physio_PCG
file_names = dir();
file_names = file_names(3:end);




for sub_id = 1:length(file_names)
id_high = [];
add_values = [];
id_diff = [];
id_endCond = [];

PCG = importdata(file_names(sub_id).name); % exported in 500 Hz

% find end points of conditions
id_high = find(PCG.data(:,2) > 4.99); % find peaks higher that 4.99
add_values = id_high(end)+5000:id_high(end)+5010;
id_high = [id_high; add_values'];
id_diff = diff(id_high); % find differences between neighbouring points
id_endCond = id_high(id_diff > 1000); % select time points (x) that mark start/end of each condition
file_names(sub_id).endPoints = length(id_endCond); 

%plot PCG and end points of conditions
figure(sub_id); plot(PCG.data(:,1), PCG.data(:,2));
ylim([-1 6]);
hold on;
plot(PCG.data(id_endCond,1), PCG.data(id_endCond,2),'*');
end
