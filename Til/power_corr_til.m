%% Script computes single Pearson correlation 
% for each pair - 37
% for each condition - 5
% for each frequency - 44
% for each electrode pair 24x24

% set filepath for loading and saving
filepath_loading = '/Volumes/til_uni/Uni/MasterthesisData/TF';
filepath_saving = '/Volumes/til_uni/Uni/MasterthesisData/sliding_pow_corr_reduced';

%% Setup
fprintf('Setup');
% Lists contain only speaker/listeners sorted by pair
[pairS,pairL] = help_getpairs;

clearvars -except pairS pairL

n_pairs = length(pairS);
n_frex = 44;
n_elex = 24;

conditions = {'RS1' 'NS' 'RS2' 'ES' 'RS3'};

% Initialize matrizes
pow_corr_p_RS1 = cell(n_pairs,n_frex,n_elex,n_elex);
pow_corr_p_NS  = cell(n_pairs,n_frex,n_elex,n_elex);
pow_corr_p_RS2 = cell(n_pairs,n_frex,n_elex,n_elex);
pow_corr_p_ES  = cell(n_pairs,n_frex,n_elex,n_elex);
pow_corr_p_RS3 = cell(n_pairs,n_frex,n_elex,n_elex);

pow_corr_r_RS1 = cell(n_pairs,n_frex,n_elex,n_elex);
pow_corr_r_NS  = cell(n_pairs,n_frex,n_elex,n_elex);
pow_corr_r_RS2 = cell(n_pairs,n_frex,n_elex,n_elex);
pow_corr_r_ES  = cell(n_pairs,n_frex,n_elex,n_elex);
pow_corr_r_RS3 = cell(n_pairs,n_frex,n_elex,n_elex);

fprintf(' - done\n');
%% Power Correlation

% check system to get correct filepath
if strcmp(getenv('USER'),'til')
    filepath = '/Volumes/til_uni/Uni/MasterthesisData/TF';
else
    filepath = '';
end

cd(filepath);
addpath(genpath(filepath))

% Loopchain: pair - condition - frequencies - electrodes
for pair = 1:length(pairS)
    tic
    for cond = 1:length(conditions)
        
        % matrix to be filled
        pow_corr_r = zeros(n_frex,n_elex,n_elex);
        pow_corr_p = zeros(n_frex,n_elex,n_elex);
        
        % load current condition for each subject of current pair
        tf_S = load(sprintf('tf_subject%s_roleS_condition%s.mat',pairS{pair},conditions{cond}));
        tf_L = load(sprintf('tf_subject%s_roleL_condition%s.mat',pairL{pair},conditions{cond}));
        fprintf('pair %d of %d loaded',pair,length(pairS));
        for freq = 1:n_frex
            
            % matrix to be filled
            pow_corr_freq_r = zeros(n_elex,n_elex);
            pow_corr_freq_p = zeros(n_elex,n_elex);
            
            for elecS = 1:n_elex
                for elecL = 1:n_elex    
                    
                    % get Data & extract power
                    pow_S = abs(tf_S.tf_elec(elecS,freq,:)).^2;
                    pow_L = abs(tf_L.tf_elec(elecL,freq,:)).^2;
                    
                    % Correlation - spearman since no normal distribution
                    [r,p]= corr(squeeze(pow_S),squeeze(pow_L),'type','spearman');
                    
                    % store r and p values in array
                    pow_corr_freq_r(elecS,elecL) = r;
                    pow_corr_freq_p(elecS,elecL) = p;
                    
                end 
            end % electrode loops
            pow_corr_r(freq,:,:) = pow_corr_freq_r;
            pow_corr_p(freq,:,:) = pow_corr_freq_p;
        end % frequency loop
        
        % fill preinitialized matrizes
        switch conditions{cond}
            case 'RS1'
                pow_corr_r_RS1(pair,:,:,:) = pow_corr_r;
                pow_corr_p_RS1(pair,:,:,:) = pow_corr_p;
            case 'NS'
                pow_corr_r_NS(pair,:,:,:)  = pow_corr_r;
                pow_corr_p_NS(pair,:,:,:)  = pow_corr_p;
            case 'RS2'
                pow_corr_r_RS2(pair,:,:,:) = pow_corr_r;
                pow_corr_p_RS2(pair,:,:,:) = pow_corr_p;
            case 'ES'
                pow_corr_r_ES(pair,:,:,:)  = pow_corr_r;
                pow_corr_p_ES(pair,:,:,:)  = pow_corr_p;
            case 'RS3'
                pow_corr_r_RS3(pair,:,:,:) = pow_corr_r;
                pow_corr_p_RS3(pair,:,:,:) = pow_corr_p;
        end
       
    end % condition loop
    % check progress
    fprintf('pair %d of %d done',pair,length(pairS));
    toc
end % pair loop


%% Save matrices
% navigate to folder

cd(filepath_saving);
addpath(genpath(filepath_saving))

% save all conditions
save('pow_corr_RS1.mat', 'pow_corr_RS1','-v7.3');
save('pow_corr_NS.mat', 'pow_corr_NS','-v7.3');
save('pow_corr_RS2.mat', 'pow_corr_RS2','-v7.3');
save('pow_corr_ES.mat', 'pow_corr_ES','-v7.3');
save('pow_corr_RS3.mat', 'pow_corr_RS3','-v7.3');




