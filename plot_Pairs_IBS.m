load('ccorr_mean_100.mat')

min_freq =  2; % in Hz
max_freq = 45; % in HZ
num_freq = 44; % in count
freqs = linspace(min_freq,max_freq,num_freq);


figure()
for freq=1:44
    subplot(11,4, freq)
    imagesc(squeeze(ccorr_rho(freq,:,:)))
    title(sprintf('%d Hz', freqs(freq)))
    colorbar
    caxis([min(ccorr_rho, [],'all') max(ccorr_rho, [],'all')])
end
sgtitle('Ccorr 200 ms window') 
set(gcf,'position',[0,0,600,1200])
saveas(gcf,'100_ccorr.png')


figure()
for freq=1:44
    subplot(11,4, freq)
    histogram(squeeze(ccorr_rho(freq,:,:)))
    title(sprintf('%d Hz', freqs(freq)))
end
sgtitle('Ccorr 100 ms window') 
set(gcf,'position',[0,0,600,1200])
saveas(gcf,'50_ccorr_hist.png')
