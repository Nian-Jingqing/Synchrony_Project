%% Load data
cd D:\Dropbox\Synchrony_Adam
addpath(genpath('D:\Dropbox\Synchrony_Adam'))

eeglab;

d = pop_loadxdf('SNS_015L_016S_N_NS.xdf'); 

% HIGH- AND LOW-PASS FILTERING
d = pop_eegfiltnew(d, 0.1, []); % 0.1 is the lower edge
d = pop_eegfiltnew(d, [], 100); % 100 is the upper edge
% remove line noise with zapline
d_tmp = permute(d.data, [2,1]);
d_tmp = nt_zapline(d_tmp, 50/500);
d.data = permute(d_tmp,[2,1]);


% plot continuous data
eegplot(d.data,'srate',d.srate,'eloc_file',d.chanlocs,'events',d.event)
