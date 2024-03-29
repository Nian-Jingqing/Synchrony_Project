% Load data
cd D:\Dropbox\Synchrony_Adam
addpath(genpath('D:\Dropbox\Synchrony_Adam'))

correlations_RS1 = zeros(23, 44, 24, 24);
correlations_RS2 = zeros(23, 44, 24, 24);
correlations_RS3 = zeros(23, 44, 24, 24);

pvalues_RS1 = zeros(23, 44, 24, 24);
pvalues_RS2 = zeros(23, 44, 24, 24);
pvalues_RS3 = zeros(23, 44, 24, 24);

num_freq = 44;

for pair = 1:23
    for condition = 1:3
        load(sprintf('tf_pair%d_condition%d_subject1.mat',pair,condition));
        tf_elec_sub1 = tf_elec;
        load(sprintf('tf_pair%d_condition%d_subject2.mat',pair,condition));
        tf_elec_sub2 = tf_elec;
        
        correlations = zeros(43,24,24);
        pvalues = zeros(43,24,24);
        
        for frequencies = 1:num_freq
            freq_c = zeros(24,24);
            freq_p = zeros(24,24);
            for electrodes_sub1 = 1:24
                data1 = squeeze(angle(tf_elec_sub1(electrodes_sub1,frequencies,:)));
                for electrodes_sub2 = 1:24
                    data2 = squeeze(angle(tf_elec_sub2(electrodes_sub2,frequencies,:)));
                    [c p] = circ_corrcc(data1,data2);
                    freq_c(electrodes_sub1,electrodes_sub2) = c;
                    freq_p(electrodes_sub1,electrodes_sub2) = p;
                end
            end
            correlations(frequencies,:,:) = freq_c;
            pvalues(frequencies,:,:) = freq_p;
        end
        
        if condition == 1
            correlations_RS1(pair,:,:,:) = correlations;
            pvalues_RS1(pair,:,:,:) = pvalues;
        elseif condition == 2
            correlations_RS2(pair,:,:,:) = correlations;
            pvalues_RS2(pair,:,:,:) = pvalues;
        elseif condition == 3
            correlations_RS3(pair,:,:,:) = correlations;
            pvalues_RS3(pair,:,:,:) = pvalues;
        end
    end
end

cd D:\Dropbox\Synchrony_Adam\EEG_Data\ccor

save('correlations_RS1.mat', 'correlations_RS1')
save('correlations_RS2.mat', 'correlations_RS2')
save('correlations_RS3.mat', 'correlations_RS3')

save('pvalues_RS1.mat', 'correlations_RS1')
save('pvalues_RS2.mat', 'correlations_RS2')
save('pvalues_RS3.mat', 'correlations_RS3')
