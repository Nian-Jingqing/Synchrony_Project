% Load data
cd D:\Dropbox\Synchrony_Adam
addpath(genpath('D:\Dropbox\Synchrony_Adam'))

pow_cor_trial_RS1 = zeros(23, 44, 24, 24);
pow_cor_trial_RS2 = zeros(23, 44, 24, 24);
pow_cor_trial_RS3 = zeros(23, 44, 24, 24);


num_freq = 44;
trial_size = 500;

for pair = 1:23
    for condition = 1:3
        load(sprintf('tf_pair%d_condition%d_subject1.mat',pair,condition));
        tf_elec_sub1 = tf_elec;
        load(sprintf('tf_pair%d_condition%d_subject2.mat',pair,condition));
        tf_elec_sub2 = tf_elec;
        
        pow_cor_trial = zeros(num_freq,24,24);
        
        n = size(tf_elec_sub1,3);
        trials = n/500;
        
        for frequencies = 1:num_freq
            pow_cor_trial_freq = zeros(24,24);
            for electrodes_sub1 = 1:24
                data1 = squeeze(abs(tf_elec_sub1(electrodes_sub1,frequencies,:)).^2);
                for electrodes_sub2 = 1:24
                    data2 = squeeze(abs(tf_elec_sub2(electrodes_sub2,frequencies,:)).^2);
                    data_trial_1 = mat2cell(data1,diff([0:trial_size:n-1,n]));
                    data_trial_2 = mat2cell(data2,diff([0:trial_size:n-1,n]));
                    trials_pow_cor_trial = zeros(trials,1);
                    for trial = 1:trials
                         tmp_pow_cor_trial_trial = corrcoef(data_trial_1{trial,1},data_trial_2{trial,1});
                         trials_pow_cor_trial(trial) = tmp_pow_cor_trial_trial(2);
                    end

                    pow_cor_trial_freq(electrodes_sub1,electrodes_sub2) = mean(trials_pow_cor_trial);
                end
            end
            pow_cor_trial(frequencies,:,:) = pow_cor_trial_freq;
        end
        
        if condition == 1
            pow_cor_trial_RS1(pair,:,:,:) = pow_cor_trial;
        elseif condition == 2
            pow_cor_trial_RS2(pair,:,:,:) = pow_cor_trial;
        elseif condition == 3
            pow_cor_trial_RS3(pair,:,:,:) = pow_cor_trial;
        end
    end
end

cd D:\Dropbox\Synchrony_Adam\EEG_Data\angle_diff

save('pow_cor_trial_RS1.mat', 'pow_cor_trial_RS1')
save('pow_cor_trial_RS2.mat', 'pow_cor_trial_RS2')
save('pow_cor_trial_RS3.mat', 'pow_cor_trial_RS3')