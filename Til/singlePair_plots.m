%% Parameters
filepath_loading = 'D:\Dropbox\Projects\Emotional_Sharing_EEG\EEG_Data\TF_new';

% navigate to folder
cd(filepath_loading);
addpath(genpath(filepath_loading))

% frequencies (from tf_til.m)
min_freq =  2; % in Hz
max_freq = 45; % in HZ
num_freq = 44; % in count
freqs = linspace(min_freq,max_freq,num_freq);
trial_size = 50;
n_electrodes = 24;
%%
% load current condition for each subject of current pair
tf_S = load('tf_subject018_roleS_conditionES.mat');
tf_L = load('tf_subject017_roleL_conditionES.mat');

n = size(tf_S.tf_elec,3);
trials = n/trial_size;


% prepare arrays
ccorr_rho  = zeros(num_freq, 24,24);
ISPC = zeros(num_freq,24,24);

ccorr_rho_trials  = zeros(num_freq, 24,24,trials);
ISPC_trials = zeros(num_freq,24,24,trials);

for frequency = 1:freqs
    
    % prepare arrays
    ccorr_rho_freq  = zeros(24,24);
    ISPC_freq = zeros(24,24);
    
    ccorr_rho_freq_trials  = zeros(24,24,trials);
    ISPC_freq_trials = zeros(24,24,trials);
    
    for electrode_sub1 = 1:24
        
        for electrode_sub2 = 1:24
            % extract data for current freqband & electrodepair
            data_S = squeeze(tf_S.tf_elec(electrode_sub1, frequency,:));
            data_L = squeeze(tf_L.tf_elec(electrode_sub2, frequency,:));
            
            angle_S = squeeze(angle(data_S))';
            angle_L = squeeze(angle(data_L))';
            
            data_trial_S_angle = mat2cell(angle_S,1,diff([0:trial_size:n-1,n])); % make epochs
            data_trial_L_angle = mat2cell(angle_L,1,diff([0:trial_size:n-1,n])); % make epochs
            
            trials_ccorr_trial = zeros(trials,1);
            trials_ISPC_trial = zeros(trials,1);
            
            for trial = 1:trials
                %ccorr
                rho_ccorr = circ_corrcl(data_trial_S_angle{trial},data_trial_L_angle{trial});
                trials_ccorr_trial(trial) = rho_ccorr;
                % ISPC/PLV
                diffs = cell2mat(data_trial_S_angle(trial)) - cell2mat(data_trial_L_angle(trial));  % Get Difference (order is irrelevant)
                euler_diffs = exp(1i*diffs); % Eulerize angles
                mean_diff = mean(euler_diffs); % mean vector
                ISPC_value = abs(mean_diff); % ISPC = length of vector (Synchronisation value)
                trials_ISPC_trial(trial) = ISPC_value;
            end
            
            ccorr_rho_freq(electrode_sub1,electrode_sub2)  = mean(trials_ccorr_trial);
            ISPC_freq(electrode_sub1,electrode_sub2) = mean(trials_ISPC_trial);
            
            ccorr_rho_freq_trials(electrode_sub1,electrode_sub2,:)  = trials_ccorr_trial;
            ISPC_freq_trials(electrode_sub1,electrode_sub2,:) = trials_ISPC_trial;
            
        end
    end % electrode loop
    
    ccorr_rho(fequency,:,:)  = ccorr_rho_freq;
    ISPC(frequency,:,:) = ISPC_band;
    
    ccorr_rho_trials(fequency,:,:)  = ccorr_rho_freq_trials;
    ISPC_trials(frequency,:,:) = ISPC_freq_trials;
    
    
end % frequency band loop
      


