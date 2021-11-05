%% Script computes Pearson correlation 
% for each pair - 37
% only between each electrode to its counterpart - 24
% at a sliding time window x ~ 6000
% for 4 frequency bands - 4
    % - Theta 3-7Hz
    % - Alpha 8-12Hz
    % - BetaA 18-22Hz
    % - BetaB 16-30Hz


%% Setup

%% Set Parameters
% Lists contain only speaker/listeners sorted by pair
[pairS,pairL] = get_pairs();

fprintf('Setup');

n_pairs = length(pairS);
n_frex = 44;
n_elex = 24;

conditions = {'RS1' 'NS' 'RS2' 'ES' 'RS3'};
freq_bands = {'theta' 'alpha' 'beta1' 'beta2'};
    
% frequencies (from tf_til.m)
min_freq =  2; % in Hz
max_freq = 45; % in HZ
num_freq = 44; % in count
freqs = linspace(min_freq,max_freq,num_freq);

theta = freqs(freqs >=  4 & freqs <=  7);
alpha = freqs(freqs >=  8 & freqs <= 12);
beta1 = freqs(freqs >= 18 & freqs <= 22);
beta2 = freqs(freqs >= 17 & freqs <= 30);

% Define moving window 
window_duration = 1; %seconds
window_intervall = 0.050; %seconds
sampling_rate = 500;

% resulting in: 
window_size = window_duration*sampling_rate; % length of window in timesteps
stride = sampling_rate * window_intervall; % amount by which window moves

fprintf(' - done\n');



%% Helperfunctions

% move a window over two datasets 
% - with a certain stride length
% - compute pearson correlation of the two windows
% - save r and p values
function [r,p] = sliding_correlation(window_size, stride, pow_S, pow_L)

    % check if datasets are equal length)
    if(length(pow_S) ~= length(pow_L))
        error('Datasets unequal lengths');
    end
    
    % setup matrices for r and p values
    r = [];
    p = [];
    % start index counter
    idx = 0;
    
    % loop:  
    for slider_pos = window_size : stride : length(pow_S)
        
        idx = idx +1;
        % cut window from datasets
        window_S =  pow_S(slider_pos-(window_size-1):slider_pos);
        window_L =  pow_L(slider_pos-(window_size-1):slider_pos);
        
        % correlate windows from both datasets
        [r(idx), p(idx)] = corr(window_S,window_L,'type','spearman');
    end
    
end


% get two lists 
% - one for speakers
% - one for listeners
% in paired order ( Pair 1 = pairS(1) & pairL(1) etc.)
function [pairS, pairL] = get_pairs()


    help_chose_analysisfolder % get filepath

    cd(filepath); %%TODO 


    % separate subjects into speaker and listener lists
    help_datacollector;

    pairS = {};
    pairL = {};

    for idx = 1:length(list_of_files)
        % split filenames
        sub_a =  list_of_files(idx).name(19:21);
        role_a = list_of_files(idx).name(22);
        sub_b =  list_of_files(idx).name(24:26);
        role_b = list_of_files(idx).name(27);


        switch role_a
            % if 1st subj is Speaker, assign to pairS...
            % and 2nd subject to pairL
            % keep members of lists unique
            case 'S'
                if(~ismember(sub_a,pairS))
                    pairS = [pairS;sub_a];
                    pairL = [pairL;sub_b];
                end
            % if 1st subj is Speaker, assign to pairL...
            % and 2nd subject to pairS
            % keep members of lists unique
            case 'L'
                if(~ismember(sub_a,pairL))
                    pairL = [pairL;sub_a];
                    pairS = [pairS;sub_b];
                end
        end
    end

    % check for pair consistency
    if(length(pairS) ~= length(pairL))
        error('Not equal amounts of speakers and listeners');
    end
end




