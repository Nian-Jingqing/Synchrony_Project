%% Load data
% through helper skript
datacollector;

%% extract pre-processing info

% create struct
Preprocessing_info = struct();
Preprocessing_info.subject = [];
Preprocessing_info.epochs = [];
Preprocessing_info.ics_removed = [];
Preprocessing_info.ch_removed = [];
Preprocessing_info.ch_list = [];


for i = 1:numel(list_of_files)
    % load next EEG file
    EEG = pop_loadset('filename', list_of_files(i).name);
    % filename
    Preprocessing_info(i).subject = EEG.subject;
    % how much data is left - max epoch is 300
    Preprocessing_info(i).epochs = length(EEG.epoch);
    % how many ICs were deleted
    Preprocessing_info(i).ics_removed = length(EEG.removed_components);
    % how many channel were deleted - and which
    Preprocessing_info(i).ch_removed = length(EEG.removed_channels);
    Preprocessing_info(i).ch_list = EEG.removed_channels;
end

% get average of rem. data/ics/channels
avg_epochs = mean([Preprocessing_info.epochs]);
avg_ics = mean([Preprocessing_info.ics_removed]);
avg_ch = mean([Preprocessing_info.ch_removed]);

% add to struct
Preprocessing_info(end+1) = struct('subject',['avg'],...
    'epochs',[avg_epochs],...
    'ics_removed',[avg_ics],...
    'ch_removed',[avg_ch],...
    'ch_list',[]);

% get std of rem. data/ics/channels
std_epochs = std([Preprocessing_info.epochs]);
std_ics = std([Preprocessing_info.ics_removed]);
std_ch = std([Preprocessing_info.ch_removed]);

% add to struct
Preprocessing_info(end+1) = struct('subject',['std'],...
    'epochs',[std_epochs],...
    'ics_removed',[std_ics],...
    'ch_removed',[std_ch],...
    'ch_list',[]);


% create csv from struct
writetable(struct2table(Preprocessing_info), 'preprocessing_info.csv')
