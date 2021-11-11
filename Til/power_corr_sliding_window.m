%% Script computes Pearson correlation 
% for each pair
% for each frequency
% between each electrode pair
% at a sliding time window


%% Parameters

% set filepath for loading and saving
filepath_loading = '/Volumes/til_uni/Uni/MasterthesisData/TF';
filepath_saving = '/Volumes/til_uni/Uni/MasterthesisData/sliding_pow_corr';


% Lists contain only speaker/listeners sorted by pair
[pairS,pairL] = get_pairs();
clearvars -except pairS pairL filepath_loading filepath_saving


fprintf('Setup');

n_pairs = length(pairS);
n_freqs = 44;
n_elecs = 24;

conditions = {'RS1' 'NS' 'RS2' 'ES' 'RS3'};

% Define moving window 
window_duration = 1; %seconds
window_intervall = 0.050; %seconds
sampling_rate = 500;

% resulting in: 
window_size = window_duration*sampling_rate; % length of window in timesteps
stride = sampling_rate * window_intervall; % amount by which window moves

fprintf(' - done\n');


%% navigate to folder

cd(filepath_loading);
addpath(genpath(filepath_loading))


%% Sliding Power Correlation


% Loopchain: pair - condition - frex - elex
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
        
        % create array from string
        sliding_pow_corr_p = zeros(n_freqs,n_elecs,n_elecs,steps);
        sliding_pow_corr_r = zeros(n_freqs,n_elecs,n_elecs,steps);
        
        
        for freq = 1:n_freqs
            
            fprintf('%i',freq);
            % matrix to be filled
            sliding_pow_corr_freq_p = zeros(n_elecs,n_elecs,steps);
            sliding_pow_corr_freq_r = zeros(n_elecs,n_elecs,steps);
            
            
            for elecS = 1:n_elecs
                % for each elec Listener
                
                for elecL = 1:n_elecs    
                    
                    % get Data & extract power
                    pow_S = squeeze(abs(tf_S.tf_elec(elecS,freq,:)).^2);
                    pow_L = squeeze(abs(tf_L.tf_elec(elecL,freq,:)).^2);
                    
                    % Correlation - spearman since no normal distribution
                    [r,p] = sliding_correlation(window_size,stride,steps,pow_S,pow_L);
                    
                    % store r and p values in array
                    sliding_pow_corr_freq_p(elecS,elecL,:) = p;
                    sliding_pow_corr_freq_r(elecS,elecL,:) = r;
                    
                end 
            end % electrode loops
            
            % save current frequency
            sliding_pow_corr_p(freq,:,:,:) = sliding_pow_corr_freq_p;
            sliding_pow_corr_r(freq,:,:,:) = sliding_pow_corr_freq_r;
            
        end % frequency loop
        
        
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



% moves to specific subfolder 
function change_dir(filepath_saving,pair,value)

    filepath = sprintf('%s/%s_values/Pair%i',filepath_saving,value,pair);
    if ~exist(filepath, 'dir')
        mkdir(filepath);
    end
    cd(filepath);
    addpath(genpath(filepath))
    
end