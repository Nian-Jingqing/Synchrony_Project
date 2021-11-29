%% Skript calculates different synchrony measures and extracts data as csv
% for each pair - 36
% for each condition - 5
% for 4 frequency bands - 4
    % - Theta 3-7Hz
    % - Alpha 8-12Hz
    % - Beta 14-30
    
% only between each electrode to its counterpart - 24

% ROIs
% frontal {F3';'F4', {'F7';'F8'}, {'Fz'},{'AFz'}} - 3,4, 11,12, 17,22
% parietal {'P3';'P4'}, {'P7';'P8'}, {'Pz'}, {'CPz';} - 7,8, 15,16, 19,23
% temporal {'T7';'T8'}, - 13,14, 
% Occipital  {'O1';'O2'} - 9,10

% not inluded 'POz', Fp1';'Fp2', Cz, M1, M2,C3,C4, 


% set filepath for loading and saving
%filepath_loading = '/Volumes/til_uni/Uni/MasterthesisData/TF';
%filepath_saving = '/Volumes/til_uni/Uni/MasterthesisData/CCorr';
filepath_loading = 'D:\Dropbox\Projects\Emotional_Sharing_EEG\EEG_Data\TF_new';
filepath_saving = 'D:\Dropbox\Projects\Emotional_Sharing_EEG\EEG_Data\ccor';

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
trial_size = 500;

% construct frequency bands
freq_band_names = {'theta' 'alpha' 'beta'};
theta = freqs(freqs >=  4 & freqs <=  7);
alpha = freqs(freqs >=  8 & freqs <= 12);
beta = freqs(freqs >= 14 & freqs <= 30);
%beta2 = freqs(freqs >= 17 & freqs <= 30);
freq_bands = {theta alpha beta};

% construct ROI
ROI_names = {'frontal' 'parietal' 'temporal' , 'occipital'};
frontal = [3 4 11 12 17 22];
parietal = [7 8 15 16 19 23];
temporal = [13 14];
occipital = [9 10];
ROIs = {frontal, parietal, temporal, occipital};

% sizes
n_pairs = length(pairS);
n_electrodes = 24;
n_conditions = length(conditions);
n_bands = length(freq_bands);
n_ROI = 4;




% setup matrices (rho and pval): 37x4x24
% (pairs-frequencybands-electrodepairs)

ccorr_rho_RS1  = zeros(n_pairs,n_bands,n_ROI);
ccorr_rho_NS   = zeros(n_pairs,n_bands,n_ROI);
ccorr_rho_RS2  = zeros(n_pairs,n_bands,n_ROI);
ccorr_rho_ES   = zeros(n_pairs,n_bands,n_ROI);
ccorr_rho_RS3  = zeros(n_pairs,n_bands,n_ROI);

pow_cor_r_RS1 = zeros(n_pairs,n_bands,n_ROI);
pow_cor_r_NS  = zeros(n_pairs,n_bands,n_ROI);
pow_cor_r_RS2 = zeros(n_pairs,n_bands,n_ROI);
pow_cor_r_ES  = zeros(n_pairs,n_bands,n_ROI);
pow_cor_r_RS3 = zeros(n_pairs,n_bands,n_ROI);

ISPC_RS1 = zeros(n_pairs,n_bands,n_ROI);
ISPC_NS  = zeros(n_pairs,n_bands,n_ROI);
ISPC_RS2 = zeros(n_pairs,n_bands,n_ROI);
ISPC_ES  = zeros(n_pairs,n_bands,n_ROI);
ISPC_RS3 = zeros(n_pairs,n_bands,n_ROI);

am_env_RS1 = zeros(n_pairs,n_bands,n_ROI);
am_env_NS  = zeros(n_pairs,n_bands,n_ROI);
am_env_RS2 = zeros(n_pairs,n_bands,n_ROI);
am_env_ES  = zeros(n_pairs,n_bands,n_ROI);
am_env_RS3 = zeros(n_pairs,n_bands,n_ROI);

%% CCorr

% Loopchain: Pairs-Conditions-frequencybands-electrodes


for pair = 1:n_pairs
    fprintf('Pair %d of %d:\n',pair,length(pairS));
    tic
    for cond = 1:n_conditions
        fprintf('Condition %s',conditions{cond});
        
        pair_sudo = randi([1 36]);
        
        % load current condition for each subject of current pair
        tf_S = load(sprintf('tf_subject%s_roleS_condition%s.mat',pairS{pair},conditions{cond}));
        tf_L = load(sprintf('tf_subject%s_roleL_condition%s.mat',pairL{pair_sudo},conditions{cond}));
        fprintf(' - loaded');
        
        n_S = size(tf_S.tf_elec,3);
        n_L = size(tf_L.tf_elec,3); 
        
        tf_S.tf_elec = tf_S.tf_elec(:,:,1:min(n_S, n_L));
        tf_L.tf_elec = tf_L.tf_elec(:,:,1:min(n_S, n_L));
        
        
        n = size(tf_S.tf_elec,3);
        trials = n/500;
        
        
        % prepare arrays
        ccorr_rho  = zeros(n_bands,n_ROI);
        pow_cor = zeros(n_bands,n_ROI);
        ISPC = zeros(n_bands,n_ROI);
        am_env = zeros(n_bands, n_ROI);
        
        for band = 1:n_bands
            
            % prepare arrays
            ccorr_rho_band  = zeros(1,n_ROI);
            pow_cor_band = zeros(1,n_ROI);
            ISPC_band = zeros(1,n_ROI);
            am_env_band = zeros(1,n_ROI);
            
            for ROI = 1:n_ROI
                
                % extract data for current freqband & electrodepair
                data_S = squeeze(tf_S.tf_elec(ROIs{ROI},freq_bands{band},:));
                data_L = squeeze(tf_L.tf_elec(ROIs{ROI},freq_bands{band},:));
                
                % average over frequencies
                data_S = squeeze(mean(data_S,2));
                data_L = squeeze(mean(data_L,2));
                
                % average over ROI
                data_S = squeeze(mean(data_S,1));
                data_L = squeeze(mean(data_L,1));
                
                amp_S = abs(data_S);
                amp_L = abs(data_L);
                
                am_env_S = envelope(amp_S);
                am_env_L = envelope(amp_L);
                
                
                pow_S = abs(data_S).^2;
                pow_L = abs(data_L).^2;
                
                angle_S = squeeze(angle(data_S));
                angle_L = squeeze(angle(data_L));
                
                
                data_trial_S_angle = mat2cell(angle_S,1,diff([0:trial_size:n-1,n])); % make 1 second epochs
                data_trial_L_angle = mat2cell(angle_L,1,diff([0:trial_size:n-1,n])); % make 1 second epochs
                
                data_trial_S_pow = mat2cell(pow_S,1,diff([0:trial_size:n-1,n])); % make 1 second epochs
                data_trial_L_pow = mat2cell(pow_L,1,diff([0:trial_size:n-1,n])); % make 1 second epochs
                
                data_trial_S_am_env = mat2cell(am_env_S,1,diff([0:trial_size:n-1,n])); % make 1 second epochs
                data_trial_L_am_env = mat2cell(am_env_L,1,diff([0:trial_size:n-1,n])); % make 1 second epochs
                
                trials_ccorr_trial = zeros(trials,1);
                trials_pow_cor_trial = zeros(trials,1);
                trials_ISPC_trial = zeros(trials,1);
                trials_am_env_trial = zeros(trials,1);
                
                for trial = 1:trials
                    %ccorr
                    rho_ccorr = circ_corrcl(data_trial_S_angle{trial},data_trial_L_angle{trial});
                    trials_ccorr_trial(trial) = rho_ccorr;
                    %pow cor
                    r_pow_cor = corr(data_trial_S_pow{trial}',data_trial_L_pow{trial}','type','spearman');
                    trials_pow_cor_trial(trial) = r_pow_cor;
                    % ISPC/PLV
                    diffs = cell2mat(data_trial_S_angle(trial)) - cell2mat(data_trial_L_angle(trial));  % Get Difference (order is irrelevant)
                    euler_diffs = exp(1i*diffs); % Eulerize angles
                    mean_diff = mean(euler_diffs); % mean vector
                    ISPC_value = abs(mean_diff); % ISPC = length of vector (Synchronisation value)
                    trials_ISPC_trial(trial) = ISPC_value;
                    %AM envelop cor
                    r_am_env = corr(data_trial_S_am_env{trial}',data_trial_L_am_env{trial}','type','pearson');
                    trials_am_env_trial(trial) = r_am_env; 
                end
                
                
                ccorr_rho_band(ROI)  = mean(trials_ccorr_trial);
                pow_cor_band(ROI) = mean(trials_pow_cor_trial);
                ISPC_band(ROI) = mean(trials_ISPC_trial);
                am_env_band(ROI) = mean(trials_am_env_trial);
                
                
            end % electrode loop
            
            ccorr_rho(band,:)  = ccorr_rho_band;
            pow_cor(band,:) = pow_cor_band;
            ISPC(band,:) = ISPC_band;
            am_env(band,:) = am_env_band; 
            
        end % frequency band loop
        
        % fill preinitialized matrizes
        switch conditions{cond}
            case 'RS1'
                ccorr_rho_RS1(pair,:,:,:)  = ccorr_rho;
                pow_cor_r_RS1(pair,:,:,:)  = pow_cor;
                ISPC_RS1(pair,:,:,:)  = ISPC;
                am_env_RS1(pair,:,:,:) = am_env;
              
            case 'NS'
                ccorr_rho_NS(pair,:,:,:)   = ccorr_rho;
                pow_cor_r_NS(pair,:,:,:)  = pow_cor;
                ISPC_NS(pair,:,:,:)  = ISPC;
                am_env_NS(pair,:,:,:) = am_env;
                
            case 'RS2'
                ccorr_rho_RS2(pair,:,:,:)  = ccorr_rho;
                pow_cor_r_RS2(pair,:,:,:)  = pow_cor;
                ISPC_RS2(pair,:,:,:)  = ISPC;
                am_env_RS2(pair,:,:,:) = am_env;
                
            case 'ES'
                ccorr_rho_ES(pair,:,:,:)   = ccorr_rho;
                pow_cor_r_ES(pair,:,:,:)  = pow_cor;
                ISPC_ES(pair,:,:,:)  = ISPC;
                am_env_ES(pair,:,:,:) = am_env;
                
            case 'RS3'
                ccorr_rho_RS3(pair,:,:,:)  = ccorr_rho;
                pow_cor_r_RS3(pair,:,:,:)  = pow_cor;
                ISPC_RS3(pair,:,:,:)  = ISPC;
                am_env_RS3(pair,:,:,:) = am_env;
                
        end
        fprintf(' - done\n');
    end % condition loop
    
    % check progress
    fprintf('Pair %d of %d done',pair,length(pairS));
    toc
    
end % pair loop

%% Save matrices

% fprintf('Saving');
% 
% cd(filepath_saving);
% addpath(genpath(filepath_saving))
% % 
% % % save all conditions
% save('ccorr_rho_RS1.mat', 'ccorr_rho_RS1','-v7.3');
% save('ccorr_rho_ES.mat',  'ccorr_rho_NS','-v7.3');
% save('ccorr_rho_RS2.mat', 'ccorr_rho_RS2','-v7.3');
% save('ccorr_rho_NS.mat',  'ccorr_rho_ES','-v7.3');
% save('ccorr_rho_RS3.mat', 'ccorr_rho_RS3','-v7.3');
% 
% 
% %fprintf(' - done\n');
% 
% 
% %save csv
cd D:\Dropbox\Projects\Emotional_Sharing_EEG\EEG_Data\ccor\csv_files_ccor_SUDO
% 
% 
% ccorr
csvwrite('R3_theta_ccorr.csv', squeeze(ccorr_rho_RS3(:,1,:)))
csvwrite('R3_alpha_ccorr.csv', squeeze(ccorr_rho_RS3(:,2,:)))
csvwrite('R3_beta__ccorr.csv', squeeze(ccorr_rho_RS3(:,3,:)))

csvwrite('R2_theta_ccorr.csv', squeeze(ccorr_rho_RS2(:,1,:)))
csvwrite('R2_alpha_ccorr.csv', squeeze(ccorr_rho_RS2(:,2,:)))
csvwrite('R2_beta__ccorr.csv', squeeze(ccorr_rho_RS2(:,3,:)))

csvwrite('R1_theta_ccorr.csv', squeeze(ccorr_rho_RS1(:,1,:)))
csvwrite('R1_alpha_ccorr.csv', squeeze(ccorr_rho_RS1(:,2,:)))
csvwrite('R1_beta__ccorr.csv', squeeze(ccorr_rho_RS1(:,3,:)))

csvwrite('ES_theta_ccorr.csv', squeeze(ccorr_rho_ES(:,1,:)))
csvwrite('ES_alpha_ccorr.csv', squeeze(ccorr_rho_ES(:,2,:)))
csvwrite('ES_beta__ccorr.csv', squeeze(ccorr_rho_ES(:,3,:)))

csvwrite('NS_theta_ccorr.csv', squeeze(ccorr_rho_NS(:,1,:)))
csvwrite('NS_alpha_ccorr.csv', squeeze(ccorr_rho_NS(:,2,:)))
csvwrite('NS_beta__ccorr.csv', squeeze(ccorr_rho_NS(:,3,:)))

% pow_cor
csvwrite('R3_theta_p_cor.csv', squeeze(pow_cor_r_RS3(:,1,:)))
csvwrite('R3_alpha_p_cor.csv', squeeze(pow_cor_r_RS3(:,2,:)))
csvwrite('R3_beta__p_cor.csv', squeeze(pow_cor_r_RS3(:,3,:)))

csvwrite('R2_theta_p_cor.csv', squeeze(pow_cor_r_RS2(:,1,:)))
csvwrite('R2_alpha_p_cor.csv', squeeze(pow_cor_r_RS2(:,2,:)))
csvwrite('R2_beta__p_cor.csv', squeeze(pow_cor_r_RS2(:,3,:)))

csvwrite('R1_theta_p_cor.csv', squeeze(pow_cor_r_RS1(:,1,:)))
csvwrite('R1_alpha_p_cor.csv', squeeze(pow_cor_r_RS1(:,2,:)))
csvwrite('R1_beta__p_cor.csv', squeeze(pow_cor_r_RS1(:,3,:)))

csvwrite('ES_theta_p_cor.csv', squeeze(pow_cor_r_ES(:,1,:)))
csvwrite('ES_alpha_p_cor.csv', squeeze(pow_cor_r_ES(:,2,:)))
csvwrite('ES_beta__p_cor.csv', squeeze(pow_cor_r_ES(:,3,:)))

csvwrite('NS_theta_p_cor.csv', squeeze(pow_cor_r_NS(:,1,:)))
csvwrite('NS_alpha_p_cor.csv', squeeze(pow_cor_r_NS(:,2,:)))
csvwrite('NS_beta__p_cor.csv', squeeze(pow_cor_r_NS(:,3,:)))

% ISPC/PLV
csvwrite('R3_theta_ispc.csv', squeeze(ISPC_RS3(:,1,:)))
csvwrite('R3_alpha_ispc.csv', squeeze(ISPC_RS3(:,2,:)))
csvwrite('R3_beta__ispc.csv', squeeze(ISPC_RS3(:,3,:)))

csvwrite('R2_theta_ispc.csv', squeeze(ISPC_RS2(:,1,:)))
csvwrite('R2_alpha_ispc.csv', squeeze(ISPC_RS2(:,2,:)))
csvwrite('R2_beta__ispc.csv', squeeze(ISPC_RS2(:,3,:)))

csvwrite('R1_theta_ispc.csv', squeeze(ISPC_RS1(:,1,:)))
csvwrite('R1_alpha_ispc.csv', squeeze(ISPC_RS1(:,2,:)))
csvwrite('R1_beta__ispc.csv', squeeze(ISPC_RS1(:,3,:)))

csvwrite('ES_theta_ispc.csv', squeeze(ISPC_ES(:,1,:)))
csvwrite('ES_alpha_ispc.csv', squeeze(ISPC_ES(:,2,:)))
csvwrite('ES_beta__ispc.csv', squeeze(ISPC_ES(:,3,:)))

csvwrite('NS_theta_ispc.csv', squeeze(ISPC_NS(:,1,:)))
csvwrite('NS_alpha_ispc.csv', squeeze(ISPC_NS(:,2,:)))
csvwrite('NS_beta__ispc.csv', squeeze(ISPC_NS(:,3,:)))

%   amplitude envelope cor
csvwrite('R3_theta_amenv.csv', squeeze(am_env_RS3(:,1,:)))
csvwrite('R3_alpha_amenv.csv', squeeze(am_env_RS3(:,2,:)))
csvwrite('R3_beta__amenv.csv', squeeze(am_env_RS3(:,3,:)))

csvwrite('R2_theta_amenv.csv', squeeze(am_env_RS2(:,1,:)))
csvwrite('R2_alpha_amenv.csv', squeeze(am_env_RS2(:,2,:)))
csvwrite('R2_beta__amenv.csv', squeeze(am_env_RS2(:,3,:)))

csvwrite('R1_theta_amenv.csv', squeeze(am_env_RS1(:,1,:)))
csvwrite('R1_alpha_amenv.csv', squeeze(am_env_RS1(:,2,:)))
csvwrite('R1_beta__amenv.csv', squeeze(am_env_RS1(:,3,:)))

csvwrite('ES_theta_amenv.csv', squeeze(am_env_ES(:,1,:)))
csvwrite('ES_alpha_amenv.csv', squeeze(am_env_ES(:,2,:)))
csvwrite('ES_beta__amenv.csv', squeeze(am_env_ES(:,3,:)))

csvwrite('NS_theta_amenv.csv', squeeze(am_env_NS(:,1,:)))
csvwrite('NS_alpha_amenv.csv', squeeze(am_env_NS(:,2,:)))
csvwrite('NS_beta__amenv.csv', squeeze(am_env_NS(:,3,:)))



