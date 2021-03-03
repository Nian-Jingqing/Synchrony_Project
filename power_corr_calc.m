% Load data
cd D:\Dropbox\Synchrony_Adam
addpath(genpath('D:\Dropbox\Synchrony_Adam'))

power_RS1 = zeros(23, 44, 24, 24);
power_RS2 = zeros(23, 44, 24, 24);
power_RS3 = zeros(23, 44, 24, 24);


num_freq = 44;

for pair = 1:23
    for condition = 1:3
        load(sprintf('tf_pair%d_condition%d_subject1.mat',pair,condition));
        tf_elec_sub1 = tf_elec;
        load(sprintf('tf_pair%d_condition%d_subject2.mat',pair,condition));
        tf_elec_sub2 = tf_elec;
        
        power_calc = zeros(num_freq,24,24);
        
        for frequencies = 1:num_freq
            power_freq = zeros(24,24);
            for electrodes_sub1 = 1:24
                data1 = squeeze(abs(tf_elec_sub1(electrodes_sub1,frequencies,:)).^2);
                for electrodes_sub2 = 1:24
                    data2 = squeeze(abs(tf_elec_sub2(electrodes_sub2,frequencies,:)).^2);
                    power_corr = corrcoef(data1,data2);
                    power_freq(electrodes_sub1,electrodes_sub2) = power_corr(2);
                end
            end
            power_calc(frequencies,:,:) = power_freq;
        end
        
        if condition == 1
            power_RS1(pair,:,:,:) = power_calc;
        elseif condition == 2
            power_RS2(pair,:,:,:) = power_calc;
        elseif condition == 3
            power_RS3(pair,:,:,:) = power_calc;
        end
    end
end

cd D:\Dropbox\Synchrony_Adam\EEG_Data\power_corr

save('power_RS1.mat', 'power_RS1')
save('power_RS2.mat', 'power_RS2')
save('power_RS3.mat', 'power_RS3')

