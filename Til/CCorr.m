%% Skript gets the Circular Correlation Coefficients
% for each pair - 37
% for each condition - 5
% for 4 frequency bands - 4
    % - Theta 3-7Hz
    % - Alpha 8-12Hz
    % - BetaA 18-22Hz
    % - BetaB 16-30Hz
% only between each electrode to its counterpart - 24


% set filepath for loading and saving
%filepath_loading = '/Volumes/til_uni/Uni/MasterthesisData/TF';
%filepath_saving = '/Volumes/til_uni/Uni/MasterthesisData/CCorr';
filepath_loading = 'D:\Dropbox\Projects\Emotional_Sharing_EEG\EEG_Data\TF_new'
filepath_saving = 'D:\Dropbox\Projects\Emotional_Sharing_EEG\EEG_Data\ccor'

% navigate to folder
cd(filepath_loading);
addpath(genpath(filepath_loading))


%% Parameters

% Lists contain only speaker/listeners sorted by pair
[pairS,pairL] = help_getpairs;
clearvars -except pairS pairL filepath_loading fileapth_saving

fprintf('Setup');
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


% sizes
n_pairs = length(pairS);
n_electrodes = 24;
n_conditions = length(conditions);
n_bands = length(freq_bands);




% setup matrices (rho and pval): 37x4x24
% (pairs-frequencybands-electrodepairs)

ccorr_rho_RS1  = zeros(n_pairs,n_bands,n_electrodes);
ccorr_rho_NS   = zeros(n_pairs,n_bands,n_electrodes);
ccorr_rho_RS2  = zeros(n_pairs,n_bands,n_electrodes);
ccorr_rho_ES   = zeros(n_pairs,n_bands,n_electrodes);
ccorr_rho_RS3  = zeros(n_pairs,n_bands,n_electrodes);

ccorr_pval_RS1 = zeros(n_pairs,n_bands,n_electrodes);
ccorr_pval_NS  = zeros(n_pairs,n_bands,n_electrodes);
ccorr_pval_RS2 = zeros(n_pairs,n_bands,n_electrodes);
ccorr_pval_ES  = zeros(n_pairs,n_bands,n_electrodes);
ccorr_pval_RS3 = zeros(n_pairs,n_bands,n_electrodes);

%% CCorr

% Loopchain: Pairs-Conditions-frequencybands-electrodes


for pair = 1:n_pairs
    fprintf('Pair %d of %d:\n',pair,length(pairS));
    tic
    for cond = 1:n_conditions
        fprintf('Condition %s',conditions{cond});
        
        % load current condition for each subject of current pair
        tf_S = load(sprintf('tf_subject%s_roleS_condition%s.mat',pairS{pair},conditions{cond}));
        tf_L = load(sprintf('tf_subject%s_roleL_condition%s.mat',pairL{pair},conditions{cond}));
        fprintf(' - loaded');

        % extract phase Angles
        angles_S = squeeze(angle(tf_S.tf_elec));
        angles_L = squeeze(angle(tf_L.tf_elec));
        
        % prepare arrays
        ccorr_rho  = zeros(n_bands,n_electrodes);
        ccorr_pval = zeros(n_bands,n_electrodes);
        
        for band = 1:n_bands
            
            % prepare arrays
            ccorr_rho_band  = zeros(1,n_electrodes);
            ccorr_pval_band = zeros(1,n_electrodes);
            
            for elec = 1:n_electrodes
                
                % extract data for current freqband & electrodepair
                data_S = squeeze(angles_S(elec,freq_bands{band},:));
                data_L = squeeze(angles_L(elec,freq_bands{band},:));
                
                % average over frequencies
                data_S = mean(data_S,1);
                data_L = mean(data_L,1);
                
                
                [rho, pval] = circ_corrcc(data_S,data_L);
                
                ccorr_rho_band(elec)  = rho;
                ccorr_pval_band(elec) = pval;

                
            end % electrode loop
            
            ccorr_rho(band,:)  = ccorr_rho_band;
            ccorr_pval(band,:) = ccorr_pval_band;
            
        end % frequency band loop
        
        % fill preinitialized matrizes
        switch conditions{cond}
            case 'RS1'
                ccorr_rho_RS1(pair,:,:,:)  = ccorr_rho;
                ccorr_pval_RS1(pair,:,:,:) = ccorr_pval;
            case 'NS'
                ccorr_rho_NS(pair,:,:,:)   = ccorr_rho;
                ccorr_pval_NS(pair,:,:,:)  = ccorr_pval;
            case 'RS2'
                ccorr_rho_RS2(pair,:,:,:)  = ccorr_rho;
                ccorr_pval_RS2(pair,:,:,:) = ccorr_pval;
            case 'ES'
                ccorr_rho_ES(pair,:,:,:)   = ccorr_rho;
                ccorr_pval_ES(pair,:,:,:)  = ccorr_pval;
            case 'RS3'
                ccorr_rho_RS3(pair,:,:,:)  = ccorr_rho;
                ccorr_pval_RS3(pair,:,:,:) = ccorr_pval;
        end
        fprintf(' - done\n');
    end % condition loop
    
    % check progress
    fprintf('Pair %d of %d done',pair,length(pairS));
    toc
    
end % pair loop

%% Save matrices

fprintf('Saving');

cd(filepath_saving);
addpath(genpath(filepath_saving))

% save all conditions
save('ccorr_rho_RS1.mat', 'ccorr_rho_RS1','-v7.3');
save('ccorr_rho_ES.mat',  'ccorr_rho_NS','-v7.3');
save('ccorr_rho_RS2.mat', 'ccorr_rho_RS2','-v7.3');
save('ccorr_rho_NS.mat',  'ccorr_rho_ES','-v7.3');
save('ccorr_rho_RS3.mat', 'ccorr_rho_RS3','-v7.3');

% save all conditions
save('ccorr_pval_RS1.mat', 'ccorr_pval_RS1','-v7.3');
save('ccorr_pval_NS.mat',  'ccorr_pval_NS','-v7.3');
save('ccorr_pval_RS2.mat', 'ccorr_pval_RS2','-v7.3');
save('ccorr_pval_ES.mat',  'ccorr_pval_ES','-v7.3');
save('ccorr_pval_RS3.mat', 'ccorr_pval_RS3','-v7.3');


fprintf(' - done\n');





