%% Load data
cd D:\Dropbox\Synchrony_Adam
addpath(genpath('D:\Dropbox\Synchrony_Adam'))

% set colormap to parula
colormap(parula)

% load correlations files
load('correlations_RS1.mat');
load('correlations_RS2.mat');
load('correlations_RS3.mat');
load('pvalues_RS1.mat');
load('pvalues_RS2.mat');
load('pvalues_RS3.mat');
load('conditions.mat');

% t test between RS1 and RS3

pvalues_RS1_RS3 = zeros(43,24,24);
tvalues_RS1_RS3 = zeros(43,24,24);


for frequency = 1:43
    for electrode_sub1 = 1:24
        for electrode_sub2 = 1:24
            [h,p,ci,stats] = ttest(correlations_RS1(:,frequency,electrode_sub1,electrode_sub2),correlations_RS2(:,frequency,electrode_sub1,electrode_sub2));
            pvalues_RS1_RS3(frequency,electrode_sub1,electrode_sub2) = p;
            tvalues_RS1_RS3(frequency,electrode_sub1,electrode_sub2) = stats.tstat;
        end
    end
end

figure()

for frequency = 1:43
subplot(7,7,frequency)
imagesc(squeeze(pvalues_RS1_RS3(frequency,:,:)));
colorbar;
caxis([0 .05]);
title(sprintf('Frequency %d Hz',frequency+1));
end

figure()

for frequency = 1:43
subplot(7,7,frequency)
imagesc(squeeze(tvalues_RS1_RS3(frequency,:,:)));
colorbar;
caxis([-7.6 6.8]);
title(sprintf('Frequency %d Hz',frequency+1));
end



% t test between RS1 and RS2 emotional (69)     

pvalues_RS1_RS2_e = zeros(43,24,24);
tvalues_RS1_RS2_e = zeros(43,24,24);


for frequency = 1:43
    for electrode_sub1 = 1:24
        for electrode_sub2 = 1:24
            [h,p,ci,stats] = ttest(correlations_RS1(conditions==69,frequency,electrode_sub1,electrode_sub2),correlations_RS2(conditions==69,frequency,electrode_sub1,electrode_sub2));
            pvalues_RS1_RS2_e(frequency,electrode_sub1,electrode_sub2) = p;
            tvalues_RS1_RS2_e(frequency,electrode_sub1,electrode_sub2) = stats.tstat;
        end
    end
end

figure()

for frequency = 1:43
subplot(7,7,frequency)
imagesc(squeeze(pvalues_RS1_RS2_e(frequency,:,:)));
colorbar;
caxis([0 .05]);
title(sprintf('Frequency %d Hz',frequency+1));
end

figure()

for frequency = 1:43
subplot(7,7,frequency)
imagesc(squeeze(tvalues_RS1_RS2_e(frequency,:,:)));
colorbar;
caxis([-7.6 6.8]);
title(sprintf('Frequency %d Hz',frequency+1));
end

% t test between RS1 and RS2 neutral (78)     

pvalues_RS1_RS2_n = zeros(43,24,24);
tvalues_RS1_RS2_n = zeros(43,24,24);


for frequency = 1:43
    for electrode_sub1 = 1:24
        for electrode_sub2 = 1:24
            [h,p,ci,stats] = ttest(correlations_RS1(conditions==78,frequency,electrode_sub1,electrode_sub2),correlations_RS2(conditions==78,frequency,electrode_sub1,electrode_sub2));
            pvalues_RS1_RS2_n(frequency,electrode_sub1,electrode_sub2) = p;
            tvalues_RS1_RS2_n(frequency,electrode_sub1,electrode_sub2) = stats.tstat;
        end
    end
end

figure()

for frequency = 1:43
subplot(7,7,frequency)
imagesc(squeeze(pvalues_RS1_RS2_n(frequency,:,:)));
colorbar;
caxis([0 .05]);
title(sprintf('Frequency %d Hz',frequency+1));
end

figure()

for frequency = 1:43
subplot(7,7,frequency)
imagesc(squeeze(tvalues_RS1_RS2_n(frequency,:,:)));
colorbar;
caxis([-7.6 6.8]);
title(sprintf('Frequency %d Hz',frequency+1));
end



% t test between RS2 and RS3 emotional (so code 78 because emotional was second)     

pvalues_RS2_RS3_e = zeros(43,24,24);
tvalues_RS2_RS3_e = zeros(43,24,24);


for frequency = 1:43
    for electrode_sub1 = 1:24
        for electrode_sub2 = 1:24
            [h,p,ci,stats] = ttest(correlations_RS2(conditions==78,frequency,electrode_sub1,electrode_sub2),correlations_RS3(conditions==78,frequency,electrode_sub1,electrode_sub2));
            pvalues_RS2_RS3_e(frequency,electrode_sub1,electrode_sub2) = p;
            tvalues_RS2_RS3_e(frequency,electrode_sub1,electrode_sub2) = stats.tstat;
        end
    end
end


figure()

for frequency = 1:43
subplot(7,7,frequency)
imagesc(squeeze(pvalues_RS2_RS3_e(frequency,:,:)));
colorbar;
caxis([0 .05]);
title(sprintf('Frequency %d Hz',frequency+1));
end

figure()

for frequency = 1:43
subplot(7,7,frequency)
imagesc(squeeze(tvalues_RS2_RS3_e(frequency,:,:)));
colorbar;
caxis([-7.6 6.8]);
title(sprintf('Frequency %d Hz',frequency+1));
end

% t test between RS2 and RS3 neutral (so code 69 because neutral was second)     

pvalues_RS2_RS3_n = zeros(43,24,24);
tvalues_RS2_RS3_n = zeros(43,24,24);


for frequency = 1:43
    for electrode_sub1 = 1:24
        for electrode_sub2 = 1:24
            [h,p,ci,stats] = ttest(correlations_RS2(conditions==69,frequency,electrode_sub1,electrode_sub2),correlations_RS3(conditions==69,frequency,electrode_sub1,electrode_sub2));
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
title(sprintf('Frequency %d Hz',frequency+1));
end

figure()

for frequency = 1:43
subplot(7,7,frequency)
imagesc(squeeze(tvalues_RS2_RS3_n(frequency,:,:)));
colorbar;
caxis([-7.6 6.8]);
title(sprintf('Frequency %d Hz',frequency+1));
end
