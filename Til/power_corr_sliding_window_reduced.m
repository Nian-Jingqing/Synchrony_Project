%% Script computes Pearson correlation 
% for each pair - 37
% only between each electrode to its counterpart - 24
% at a sliding time window x ~ 6000
% for 4 frequency bands - 4
    % - Theta 3-7Hz
    % - Alpha 8-12Hz
    % - BetaA 18-22Hz
    % - BetaB 16-30Hz

% set filepath for loading and saving
filepath_loading = '/Volumes/til_uni/Uni/MasterthesisData/TF';
filepath_saving = '/Volumes/til_uni/Uni/MasterthesisData/sliding_pow_corr_reduced';

%% Parameters

% Lists contain only speaker/listeners sorted by pair
[pairS,pairL] = help_getpairs;
clearvars -except pairS pairL filepath_loading filepath_saving


n_pairs = length(pairS);
n_elecs = 24;

conditions = {'RS1' 'NS' 'RS2' 'ES' 'RS3'};

% frequencies (from tf_til.m)
min_freq =  2; % in Hz
max_freq = 45; % in HZ
num_freq = 44; % in count
freqs = linspace(min_freq,max_freq,num_freq);

% construct frequency bands
freq_band_names = {'theta' 'alpha' 'beta1' 'beta2'};
theta = freqs(freqs >=  4 & freqs <=  7);
alpha = freqs(freqs >=  8 & freqs <= 12);
beta1 = freqs(freqs >= 18 & freqs <= 22);
beta2 = freqs(freqs >= 17 & freqs <= 30);
freq_bands = {theta alpha beta1 beta2};


% Define moving window 
window_duration = 1; %seconds
window_intervall = 0.050; %seconds
sampling_rate = 500;

% resulting in: 
window_size = window_duration*sampling_rate; % length of window in timesteps
stride = sampling_rate * window_intervall; % amount by which window moves

fprintf('Setup - done\n');

%% navigate to folder

cd(filepath_loading);
addpath(genpath(filepath_loading))

%% Sliding Power Correlation

% Loopchain: pair - condition - freq_bands - electrodes
for pair = 1:length(pairS) 
    tic
    fprintf('pair %d of %d:\n',pair,length(pairS));
    for cond = 1:length(conditions)
        fprintf('Condition %s',conditions{cond});
        
        % load current condition for each subject(S&L) of current pair
        tf_S = load(sprintf('tf_subject%s_roleS_condition%s.mat',pairS{pair},conditions{cond}));
        tf_L = load(sprintf('tf_subject%s_roleL_condition%s.mat',pairL{pair},conditions{cond}));
        fprintf(' - loaded');
        
        % prepare array
        % calculate number of power_correlations taken to set up array
        timepoints = size(tf_S.tf_elec,3); % check recording length of files
        steps = floor((timepoints - window_size) / stride) + 1;
        
        % create array
        sliding_pow_corr_r = zeros(length(freq_bands),n_elecs,steps);
        sliding_pow_corr_p = zeros(length(freq_bands),n_elecs,steps);
        
        for band = 1:length(freq_bands)
            
            % get Data & extract power
            pow_S = squeeze(abs(tf_S.tf_elec(:,freq_bands{band},:)).^2);
            pow_L = squeeze(abs(tf_L.tf_elec(:,freq_bands{band},:)).^2);
            
            % average over freq band
            avg_pow_S = squeeze(mean(pow_S,2));
            avg_pow_L = squeeze(mean(pow_L,2));
            
            % create array for band
            sliding_pow_corr_band_r = zeros(n_elecs,steps);
            sliding_pow_corr_band_p = zeros(n_elecs,steps);

            for elec = 1:n_elecs
                
                % correlate Speaker and Listener using sliding window
                S = transpose(avg_pow_S(elec,:));
                L = transpose(avg_pow_L(elec,:));
                [r,p] = sliding_correlation(window_size,stride,steps,S,L);
                
                % store r and p values in array
                sliding_pow_corr_band_r(elec,:) = r;
                sliding_pow_corr_band_p(elec,:) = p;


                
            end % electrode loop
            sliding_pow_corr_r(band,:,:) = sliding_pow_corr_band_r;
            sliding_pow_corr_p(band,:,:) = sliding_pow_corr_band_p;
            
            
        end % frequency band loop
        
        % save current condition in respective subfolder
        change_dir(filepath_saving,pair,'p');
        save(sprintf('sliding_pow_corr_p_pair%i_%s.mat',pair,conditions{cond}),...
            'sliding_pow_corr_p','-v7.3');
 
        change_dir(filepath_saving,pair,'r');
        save(sprintf('sliding_pow_corr_r_pair%i_%s.mat',pair,conditions{cond}),...
            'sliding_pow_corr_r','-v7.3');
        
     	fprintf(' - done\n');
        
    end % condition loop
    
    fprintf('Pair %d of %d done',pair,length(pairS));
    
    toc
    
end % pair loop





%% Helperfunctions

% move a window over two datasets 
% - with a certain stride length
% - compute pearson correlation of the two windows
% - save r and p values
function [r,p] = sliding_correlation(window_size, stride, steps, dataA, dataB)

    % check if datasets are equal length)
    if(length(dataA) ~= length(dataB))
        error('Datasets have unequal length');
    end
    
    % setup matrices for r and p values
    r = zeros(1,steps);
    p = zeros(1,steps);
    % start index counter
    idx = 0;
    
    % loop:  
    for slider_pos = window_size : stride : length(dataA)
        
        idx = idx +1;
        % cut window from datasets
        window_S =  dataA(slider_pos-(window_size-1):slider_pos);
        window_L =  dataB(slider_pos-(window_size-1):slider_pos);
        
        % correlate windows from both datasets
        [rval, pval] = corr(window_S,window_L,'type','spearman');
        r(idx) = rval;
        p(idx) = pval;
    end
    
end



% creates and moves to specific subfolder 
function change_dir(filepath_saving,pair,value)

    filepath = sprintf('%s/%s_values/Pair%i',filepath_saving,value,pair);
    if ~exist(filepath, 'dir')
        mkdir(filepath);
    end
    cd(filepath);
    addpath(genpath(filepath))
    
end