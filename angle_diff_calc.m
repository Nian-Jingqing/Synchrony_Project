% Load data
cd D:\Dropbox\Synchrony_Adam
addpath(genpath('D:\Dropbox\Synchrony_Adam'))

angle_diff_RS1 = zeros(23, 44, 24, 24);
angle_diff_RS2 = zeros(23, 44, 24, 24);
angle_diff_RS3 = zeros(23, 44, 24, 24);


num_freq = 44;
trial_size = 500;

for pair = 1:23
    for condition = 1:3
        load(sprintf('tf_pair%d_condition%d_subject1.mat',pair,condition));
        tf_elec_sub1 = tf_elec;
        load(sprintf('tf_pair%d_condition%d_subject2.mat',pair,condition));
        tf_elec_sub2 = tf_elec;
        
        angle_diff = zeros(num_freq,24,24);
        
        n = size(tf_elec_sub1,3);
        trials = n/500;
        
        for frequencies = 1:num_freq
            angle_diff_freq = zeros(24,24);
            for electrodes_sub1 = 1:24
                data1 = squeeze(angle(tf_elec_sub1(electrodes_sub1,frequencies,:)));
                for electrodes_sub2 = 1:24
                    data2 = squeeze(angle(tf_elec_sub2(electrodes_sub2,frequencies,:)));
                    data_trial_1 = mat2cell(data1,diff([0:trial_size:n-1,n]));
                    data_trial_2 = mat2cell(data2,diff([0:trial_size:n-1,n]));
                    trials_angle_diff = zeros(trials,1);
                    for trial = 1:trials
                         trials_angle_diff(trial) = mean(angdiff(data_trial_1{trial,1}-data_trial_2{trial,1}));
                    end

                    angle_diff_freq(electrodes_sub1,electrodes_sub2) = mean(trials_angle_diff);
                end
            end
            angle_diff(frequencies,:,:) = angle_diff_freq;
        end
        
        if condition == 1
            angle_diff_RS1(pair,:,:,:) = angle_diff;
        elseif condition == 2
            angle_diff_RS2(pair,:,:,:) = angle_diff;
        elseif condition == 3
            angle_diff_RS3(pair,:,:,:) = angle_diff;
        end
    end
end

cd D:\Dropbox\Synchrony_Adam\EEG_Data\angle_diff

save('angle_diff_RS1.mat', 'angle_diff_RS1')
save('angle_diff_RS2.mat', 'angle_diff_RS2')
save('angle_diff_RS3.mat', 'angle_diff_RS3')


