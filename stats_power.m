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
load('power_RS1.mat');
load('power_RS2.mat');
load('power_RS3.mat');
load('conditions.mat');

% t test between RS1 and RS3

pvalues_RS1_RS3 = zeros(43,24,24);
tvalues_RS1_RS3 = zeros(43,24,24);


for frequency = 1:num_freq
    for electrode_sub1 = 1:24
        for electrode_sub2 = 1:24
            [h,p,ci,stats] = ttest(power_RS1(:,frequency,electrode_sub1,electrode_sub2),power_RS3(:,frequency,electrode_sub1,electrode_sub2));
            pvalues_RS1_RS3(frequency,electrode_sub1,electrode_sub2) = p;
            tvalues_RS1_RS3(frequency,electrode_sub1,electrode_sub2) = stats.tstat;
        end
    end
end

figure()

for frequency = 1:num_freq
subplot(7,7,frequency)
imagesc(squeeze(pvalues_RS1_RS3(frequency,:,:)));
colorbar;
caxis([0 .05]);
title(sprintf('Frequency %.2f Hz',round(frex(frequency),2)));
end

%tmp = pvalues_RS1_RS3 < .05;

figure()

for frequency = 1:num_freq
subplot(7,7,frequency)
imagesc(squeeze(tvalues_RS1_RS3(frequency,:,:)));
colorbar;
caxis([-8.9 6.9]);
title(sprintf('Frequency %.2f Hz',round(frex(frequency),2)));
end



% t test between RS1 and RS2 emotional (69)     

pvalues_RS1_RS2_e = zeros(43,24,24);
tvalues_RS1_RS2_e = zeros(43,24,24);


for frequency = 1:num_freq
    for electrode_sub1 = 1:24
        for electrode_sub2 = 1:24
            [h,p,ci,stats] = ttest(power_RS1(conditions==69,frequency,electrode_sub1,electrode_sub2),power_RS2(conditions==69,frequency,electrode_sub1,electrode_sub2));
            pvalues_RS1_RS2_e(frequency,electrode_sub1,electrode_sub2) = p;
            tvalues_RS1_RS2_e(frequency,electrode_sub1,electrode_sub2) = stats.tstat;
        end
    end
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
imagesc(squeeze(tvalues_RS1_RS2_e(frequency,:,:)));
colorbar;
caxis([-8.9 6.9]);
title(sprintf('Frequency %.2f Hz',round(frex(frequency),2)));
end

% t test between RS1 and RS2 neutral (78)     

pvalues_RS1_RS2_n = zeros(43,24,24);
tvalues_RS1_RS2_n = zeros(43,24,24);


for frequency = 1:num_freq
    for electrode_sub1 = 1:24
        for electrode_sub2 = 1:24
            [h,p,ci,stats] = ttest(power_RS1(conditions==78,frequency,electrode_sub1,electrode_sub2),power_RS2(conditions==78,frequency,electrode_sub1,electrode_sub2));
            pvalues_RS1_RS2_n(frequency,electrode_sub1,electrode_sub2) = p;
            tvalues_RS1_RS2_n(frequency,electrode_sub1,electrode_sub2) = stats.tstat;
        end
    end
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
imagesc(squeeze(tvalues_RS1_RS2_n(frequency,:,:)));
colorbar;
caxis([-8.9 6.9]);
title(sprintf('Frequency %.2f Hz',round(frex(frequency),2)));
end



% t test between RS2 and RS3 emotional (so code 78 because emotional was second)     

pvalues_RS2_RS3_e = zeros(43,24,24);
tvalues_RS2_RS3_e = zeros(43,24,24);


for frequency = 1:num_freq
    for electrode_sub1 = 1:24
        for electrode_sub2 = 1:24
            [h,p,ci,stats] = ttest(power_RS2(conditions==78,frequency,electrode_sub1,electrode_sub2),power_RS3(conditions==78,frequency,electrode_sub1,electrode_sub2));
            pvalues_RS2_RS3_e(frequency,electrode_sub1,electrode_sub2) = p;
            tvalues_RS2_RS3_e(frequency,electrode_sub1,electrode_sub2) = stats.tstat;
        end
    end
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

for frequency = 1:num_freq
subplot(7,7,frequency)
imagesc(squeeze(tvalues_RS2_RS3_e(frequency,:,:)));
colorbar;
caxis([-8.9 6.9]);
title(sprintf('Frequency %.2f Hz',round(frex(frequency),2)));
end

% t test between RS2 and RS3 neutral (so code 69 because neutral was second)     

pvalues_RS2_RS3_n = zeros(43,24,24);
tvalues_RS2_RS3_n = zeros(43,24,24);


for frequency = 1:43
    for electrode_sub1 = 1:24
        for electrode_sub2 = 1:24
            [h,p,ci,stats] = ttest(power_RS2(conditions==69,frequency,electrode_sub1,electrode_sub2),power_RS3(conditions==69,frequency,electrode_sub1,electrode_sub2));
            pvalues_RS2_RS3_n(frequency,electrode_sub1,electrode_sub2) = p;
            tvalues_RS2_RS3_n(frequency,electrode_sub1,electrode_sub2) = stats.tstat;
        end
    end
end

figure()

for frequency = 1:43
subplot(7,7,frequency)
imagesc(squeeze(pvalues_RS2_RS3_n(frequency,:,:)));
colorbar;
caxis([0 .05]);
title(sprintf('Frequency %.2f Hz',round(frex(frequency),2)));
end

figure()

for frequency = 1:43
subplot(7,7,frequency)
imagesc(squeeze(tvalues_RS2_RS3_n(frequency,:,:)));
colorbar;
caxis([-8.9 6.9]);
title(sprintf('Frequency %.2f Hz', round(frex(frequency),2)));
end
