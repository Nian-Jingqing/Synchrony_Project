%% Skript plots ISPC over time
% for subject
% for condition
% for 4 freq bands
    % - Theta 3-7Hz
    % - Alpha 8-12Hz
    % - BetaA 18-22Hz
    % - BetaB 16-30Hz
% for 24 electrode pairs (Fz-Fz etc)
    
% set filepath for loading 
filepath_loading = '/Volumes/til_uni/Uni/MasterthesisData/sliding_pow_corr_reduced/r_values';

%%

cd(filepath_loading);
addpath(genpath(filepath_loading));

conditions = {'RS1' 'NS' 'RS2' 'ES' 'RS3'};


%% plot for one pair

pair = 1;

figure
for cond = 1:length(conditions)
    load(sprintf('sliding_pow_corr_r_pair%i_%s',pair,conditions{cond}));

    mean_over_electrodes = squeeze(mean(sliding_pow_corr_r,2));

    subplot(5,1,cond)
    plot(mean_over_electrodes(1,:))
    xlim([0 6000]);
end