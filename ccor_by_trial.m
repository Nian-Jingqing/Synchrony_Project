% Load data
cd D:\Dropbox\Synchrony_Adam
addpath(genpath('D:\Dropbox\Synchrony_Adam'))

ccor_trials_RS1 = zeros(23, 44, 24, 24);
ccor_trials_RS2 = zeros(23, 44, 24, 24);
ccor_trials_RS3 = zeros(23, 44, 24, 24);


num_freq = 44;
trial_size = 500;

for pair = 1:23
    for condition = 1:3
        load(sprintf('tf_pair%d_condition%d_subject1.mat',pair,condition));
        tf_elec_sub1 = tf_elec;
        load(sprintf('tf_pair%d_condition%d_subject2.mat',pair,condition));
        tf_elec_sub2 = tf_elec;

        n = size(tf_elec_sub1,3);
        trials = n/500;
        
        ccor_all = zeros(num_freq,24,24);
        
        for frequencies = 1:num_freq
            ccor_freq = zeros(24,24);
            for electrodes_sub1 = 1:24
                data1 = squeeze(angle(tf_elec_sub1(electrodes_sub1,frequencies,:)));
                for electrodes_sub2 = 1:24
                    data2 = squeeze(angle(tf_elec_sub2(electrodes_sub2,frequencies,:)));
                    data_trial_1 = mat2cell(data1,diff([0:trial_size:n-1,n]));
                    data_trial_2 = mat2cell(data2,diff([0:trial_size:n-1,n]));
                    trials_ccor = zeros(trials,1);
                    for trial = 1:trials
                        [c p] = circ_corrcc(data_trial_1{trial,1},data_trial_2{trial,1});
                        trials_ccor(trial) = c;
                    end
                    ccor_avg = mean(trials_ccor);
                    ccor_freq(electrodes_sub1,electrodes_sub2) = ccor_avg;
                end
            end
            ccor_all(frequencies,:,:) = ccor_freq;
        end
        
        if condition == 1
            ccor_trials_RS1(pair,:,:,:) = ccor_all;
        elseif condition == 2
            ccor_trials_RS2(pair,:,:,:) = ccor_all;
        elseif condition == 3
            ccor_trials_RS3(pair,:,:,:) = ccor_all;
        end
    end
end

cd D:\Dropbox\Synchrony_Adam\EEG_Data\ccor\ccor_by_trial

save('ccor_trials_RS1.mat', 'ccor_trials_RS1')
save('ccor_trials_RS2.mat', 'ccor_trials_RS2')
save('ccor_trials_RS3.mat', 'ccor_trials_RS3')
