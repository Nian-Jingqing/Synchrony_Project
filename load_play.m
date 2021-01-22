%% Load data
cd D:\Dropbox\Synchrony_Adam
addpath(genpath('D:\Dropbox\Synchrony_Adam'))
eeglabpath = fileparts(which('eeglab.m'));
% load eeglab
eeglab;

%
eeg_sub1 = pop_loadset('hyper_cleaned_SNS_015L_016S_N_NS_sub_1.set');
eeg_sub2 = pop_loadset('hyper_cleaned_SNS_015L_016S_N_NS_sub_2.set');

count = 1;

for event_id = 1:numel(eeg_sub1.event)
    if isequal(eeg_sub1.event(event_id).type, 'chan25')
        eeg_sub1.event(event_id).epoch_id = count;
        count = count + 1;
    else
        eeg_sub1.event(event_id).epoch_id = 0;
    end
    
end

count = 1;

for event_id = 1:numel(eeg_sub2.event)
    if isequal(eeg_sub2.event(event_id).type, 'chan25')
        eeg_sub2.event(event_id).epoch_id = count;
        count = count + 1;
    else
        eeg_sub2.event(event_id).epoch_id = 0;
    end
    
end


%EPOCH %%%
window = [0 .999];
eeg_sub1 = pop_epoch( eeg_sub1, {'chan25'}, window, 'epochinfo', 'yes');
eeg_sub2 = pop_epoch( eeg_sub2, {'chan25'}, window, 'epochinfo', 'yes');

% finds trials that are present in both subjects
[val1 pos1] = intersect([eeg_sub1.event.epoch_id], [eeg_sub2.event.epoch_id]);
[val2 pos2] = intersect([eeg_sub2.event.epoch_id], [eeg_sub1.event.epoch_id]);






