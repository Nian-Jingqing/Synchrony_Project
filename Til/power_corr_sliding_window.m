%% Script computes Pearson correlation 
% for each pair
% for each frequency
% between each electrode pair
% at a sliding time window

%% Set Parameters
% Lists contain only speaker/listeners sorted by pair
[pairS,pairL] = get_pairs();
clearvars -except pairS pairL

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

% check system to get correct filepath
if strcmp(getenv('USER'),'til')
    filepath = '/Volumes/til_uni/Uni/MasterthesisData/TF';
else
    filepath = '';
end

cd(filepath);
addpath(genpath(filepath))


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
        
        
        % prepare cell
        % calculate number of power_correlations taken to set up cell
        timepoints = size(tf_S.tf_elec,3); % check recording length of files
        steps = floor((timepoints - window_size) / stride) + 1;
        
        % create cell from string
        sliding_pow_cor = cell(n_freqs,n_elecs,n_elecs,steps);
        
        
        
        for freq = 1:n_freqs
            
            % matrix to be filled
            sliding_pow_cor_freq = cell(n_elecs,n_elecs,steps);
            
            
            for elecS = 1:n_elecs
                % for eaach elec Listener
                for elecL = 1:n_elecs    
                    
                    % get Data & extract power
                    pow_S = squeeze(abs(tf_S.tf_elec(elecS,freq,:)).^2);
                    pow_L = squeeze(abs(tf_L.tf_elec(elecL,freq,:)).^2);
                    
                    % Correlation - spearman since no normal distribution
                    [r,p] = sliding_correlation(window_size,stride,pow_S,pow_L);
                    
                    % store r and p values in cell
                    sliding_pow_cor_freq(elecS,elecL,:) = {[r,p]};
                    
                end 
            end % electrode loops
            
            % save current frequency
            sliding_pow_cor(freq,:,:,:) = sliding_pow_cor_freq;
            
        end % frequency loop
        
        % save current condition
        % rename cell - include condition name
        assignin('base', sprintf('sliding_pow_cor_%s',conditions{cond}),...
                sliding_pow_corr)

    	fprintf(' - done\n');
        
    end % condition loop
    
    fprintf('Saving');

    % check system to get correct filepath
    if strcmp(getenv('USER'),'til')
        filepath = sprintf('/Volumes/til_uni/Uni/MasterthesisData/sliding_pow_corr/Pair%i',pair);
        if ~exist(filepath, 'dir')
            mkdir(filepath);
        end
    else
        filepath = '';
        if ~exist(filepath, 'dir')
            mkdir(filepath);
        end
    end

    cd(filepath);
    addpath(genpath(filepath))

    % save all conditions for current pair
    save(sprintf('sliding_pow_cor_RS1_pair%i.mat',pair), 'sliding_pow_cor_RS1','-v7.3');
    save(sprintf('sliding_pow_cor_NS_pair%i.mat',pair),  'sliding_pow_cor_NS','-v7.3');
    save(sprintf('sliding_pow_cor_RS2_pair%i.mat',pair), 'sliding_pow_cor_RS2','-v7.3');
    save(sprintf('sliding_pow_cor_ES_pair%i.mat',pair),  'sliding_pow_cor_ES','-v7.3');
    save(sprintf('sliding_pow_cor_RS3_pair%i.mat',pair), 'sliding_pow_cor_RS3','-v7.3');
    
    fprintf(' - done\n'); 
    fprintf('Pair %d of %d done',pair,length(pairS));
    toc
end % pair loop

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




