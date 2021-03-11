%% Load data
cd D:\Dropbox\Synchrony_Adam
addpath(genpath('D:\Dropbox\Synchrony_Adam'))

% set colormap to parula
colormap(parula);
num_freq = 44;
min_freq =  2; % in Hz
max_freq = 45; % in HZ


frex  = logspace(log10(min_freq),log10(max_freq),num_freq);

% load angle difference files
load('pow_cor_trial_RS1.mat');
load('pow_cor_trial_RS2.mat');
load('pow_cor_trial_RS3.mat');
load('conditions.mat');

% t test between RS1 and RS3

pvalues_RS1_RS3 = zeros(43,24,24);
tvalues_RS1_RS3 = zeros(43,24,24);


for frequency = 1:num_freq
    for electrode_sub1 = 1:24
        for electrode_sub2 = 1:24
            [h,p,ci,stats] = ttest(pow_cor_trial_RS1(:,frequency,electrode_sub1,electrode_sub2),pow_cor_trial_RS3(:,frequency,electrode_sub1,electrode_sub2));
            pvalues_RS1_RS3(frequency,electrode_sub1,electrode_sub2) = p;
            tvalues_RS1_RS3(frequency,electrode_sub1,electrode_sub2) = stats.tstat;
        end
    end
end

% t test between RS1 and RS2 emotional (69)     

pvalues_RS1_RS2_e = zeros(43,24,24);
tvalues_RS1_RS2_e = zeros(43,24,24);


for frequency = 1:num_freq
    for electrode_sub1 = 1:24
        for electrode_sub2 = 1:24
            [h,p,ci,stats] = ttest(pow_cor_trial_RS1(conditions==69,frequency,electrode_sub1,electrode_sub2),pow_cor_trial_RS2(conditions==69,frequency,electrode_sub1,electrode_sub2));
            pvalues_RS1_RS2_e(frequency,electrode_sub1,electrode_sub2) = p;
            tvalues_RS1_RS2_e(frequency,electrode_sub1,electrode_sub2) = stats.tstat;
        end
    end
end

% t test between RS1 and RS2 neutral (78)     

pvalues_RS1_RS2_n = zeros(43,24,24);
tvalues_RS1_RS2_n = zeros(43,24,24);


for frequency = 1:num_freq
    for electrode_sub1 = 1:24
        for electrode_sub2 = 1:24
            [h,p,ci,stats] = ttest(pow_cor_trial_RS1(conditions==78,frequency,electrode_sub1,electrode_sub2),pow_cor_trial_RS2(conditions==78,frequency,electrode_sub1,electrode_sub2));
            pvalues_RS1_RS2_n(frequency,electrode_sub1,electrode_sub2) = p;
            tvalues_RS1_RS2_n(frequency,electrode_sub1,electrode_sub2) = stats.tstat;
        end
    end
end

% t test between RS2 and RS3 emotional (so code 78 because emotional was second)     

pvalues_RS2_RS3_e = zeros(43,24,24);
tvalues_RS2_RS3_e = zeros(43,24,24);


for frequency = 1:num_freq
    for electrode_sub1 = 1:24
        for electrode_sub2 = 1:24
            [h,p,ci,stats] = ttest(pow_cor_trial_RS2(conditions==78,frequency,electrode_sub1,electrode_sub2),pow_cor_trial_RS3(conditions==78,frequency,electrode_sub1,electrode_sub2));
            pvalues_RS2_RS3_e(frequency,electrode_sub1,electrode_sub2) = p;
            tvalues_RS2_RS3_e(frequency,electrode_sub1,electrode_sub2) = stats.tstat;
        end
    end
end

% t test between RS2 and RS3 neutral (so code 69 because neutral was second)     

pvalues_RS2_RS3_n = zeros(43,24,24);
tvalues_RS2_RS3_n = zeros(43,24,24);


for frequency = 1:43
    for electrode_sub1 = 1:24
        for electrode_sub2 = 1:24
            [h,p,ci,stats] = ttest(pow_cor_trial_RS2(conditions==69,frequency,electrode_sub1,electrode_sub2),pow_cor_trial_RS3(conditions==69,frequency,electrode_sub1,electrode_sub2));
            pvalues_RS2_RS3_n(frequency,electrode_sub1,electrode_sub2) = p;
            tvalues_RS2_RS3_n(frequency,electrode_sub1,electrode_sub2) = stats.tstat;
        end
    end
end

%% figures p values


figure()

for frequency = 1:num_freq
subplot(7,7,frequency)
imagesc(squeeze(pvalues_RS1_RS3(frequency,:,:)));
colorbar;
caxis([0 .05]);
title(sprintf('Frequency %.2f Hz',round(frex(frequency),2)));
end

figure()

for frequency = 1:num_freq
subplot(7,7,frequency)
imagesc(squeeze(pvalues_RS1_RS2_e(frequency,:,:)));
colorbar;
caxis([0 .05]);
title(sprintf('Frequency %.2f Hz', round(frex(frequency),2)));
end

figure()

for frequency = 1:num_freq
subplot(7,7,frequency)
imagesc(squeeze(pvalues_RS1_RS2_n(frequency,:,:)));
colorbar;
caxis([0 .05]);
title(sprintf('Frequency %.2f Hz',round(frex(frequency),2)));
end

figure()

for frequency = 1:num_freq
subplot(7,7,frequency)
imagesc(squeeze(pvalues_RS2_RS3_e(frequency,:,:)));
colorbar;
caxis([0 .05]);
title(sprintf('Frequency %.2f Hz',round(frex(frequency),2)));
end

figure()

for frequency = 1:43
subplot(7,7,frequency)
imagesc(squeeze(pvalues_RS2_RS3_n(frequency,:,:)));
colorbar;
caxis([0 .05]);
title(sprintf('Frequency %.2f Hz',round(frex(frequency),2)));
end



%% figures t-values



max_t = max([max(max(max(tvalues_RS1_RS3))) max(max(max(tvalues_RS1_RS2_e))) max(max(max(tvalues_RS1_RS2_n))) max(max(max(tvalues_RS2_RS3_e))) max(max(max(tvalues_RS2_RS3_n)))]);
min_t = min([min(min(min(tvalues_RS1_RS3))) min(min(min(tvalues_RS1_RS2_e))) min(min(min(tvalues_RS1_RS2_n))) min(min(min(tvalues_RS2_RS3_e))) min(min(min(tvalues_RS2_RS3_n)))]);



figure()

for frequency = 1:num_freq
subplot(7,7,frequency)
imagesc(squeeze(tvalues_RS1_RS3(frequency,:,:)));
colorbar;
caxis([min_t max_t]);
title(sprintf('Frequency %.2f Hz',round(frex(frequency),2)));
end


figure()

for frequency = 1:num_freq
subplot(7,7,frequency)
imagesc(squeeze(tvalues_RS1_RS2_e(frequency,:,:)));
colorbar;
caxis([min_t max_t]);
title(sprintf('Frequency %.2f Hz',round(frex(frequency),2)));
end

figure()

for frequency = 1:num_freq
subplot(7,7,frequency)
imagesc(squeeze(tvalues_RS1_RS2_n(frequency,:,:)));
colorbar;
caxis([min_t max_t]);
title(sprintf('Frequency %.2f Hz',round(frex(frequency),2)));
end

figure()

for frequency = 1:num_freq
subplot(7,7,frequency)
imagesc(squeeze(tvalues_RS2_RS3_e(frequency,:,:)));
colorbar;
caxis([min_t max_t]);
title(sprintf('Frequency %.2f Hz',round(frex(frequency),2)));
end

figure()

for frequency = 1:43
subplot(7,7,frequency)
imagesc(squeeze(tvalues_RS2_RS3_n(frequency,:,:)));
colorbar;
caxis([min_t max_t]);
title(sprintf('Frequency %.2f Hz', round(frex(frequency),2)));
end

%% calculate % of p-values < .05

pvalues_RS1_RS3_ratio = (sum(pvalues_RS1_RS3 < .05, 'all')/(num_freq*24*24)) * 100;
pvalues_RS1_RS2_e_ratio = (sum(pvalues_RS1_RS2_e < .05, 'all')/(num_freq*24*24)) * 100;
pvalues_RS1_RS2_n_ratio = (sum(pvalues_RS1_RS2_n < .05, 'all')/(num_freq*24*24)) * 100;
pvalues_RS2_RS3_e_ratio = (sum(pvalues_RS2_RS3_e < .05, 'all')/(num_freq*24*24)) * 100;
pvalues_RS2_RS3_n_ratio = (sum(pvalues_RS2_RS3_n < .05, 'all')/(num_freq*24*24)) * 100;

pvalues_RS1_RS3_ratio
pvalues_RS1_RS2_e_ratio
pvalues_RS1_RS2_n_ratio
pvalues_RS2_RS3_e_ratio
pvalues_RS2_RS3_n_ratio

