%% Load data
cd D:\Dropbox\Synchrony_Adam
addpath(genpath('D:\Dropbox\Synchrony_Adam'))
eeglabpath = fileparts(which('eeglab.m'));
% load eeglab
eeglab;


cd D:\Dropbox\Synchrony_Adam\EEG_Data\Preprocessed\hyper_cleaned\
list_of_files = dir('**/*ES_sub_1.set');

pairs_A = {'003' '005' '007' '009' '013' '015' '017' '019' '021' '023' '025' '027' '029' '031' '037' '039' '041' '045' '047' '049' '051' '053' '055'};
pairs_B = {'004' '006' '008' '010' '014' '016' '018' '020' '022' '024' '026' '028' '030' '032' '038' '040' '042' '046' '048' '050' '052' '054' '056'};


theta_speakers_e = zeros(24,23);
alpha_speakers_e = zeros(24,23);
beta_speakers_e = zeros(24,23);
gamma_speakers_e = zeros(24,23);

theta_speakers_n = zeros(24,23);
alpha_speakers_n = zeros(24,23);
beta_speakers_n = zeros(24,23);
gamma_speakers_n = zeros(24,23);


theta_listeners_e = zeros(24,23);
alpha_listeners_e = zeros(24,23);
beta_listeners_e = zeros(24,23);
gamma_listeners_e = zeros(24,23);

theta_listeners_n = zeros(24,23);
alpha_listeners_n = zeros(24,23);
beta_listeners_n = zeros(24,23);
gamma_listeners_n = zeros(24,23);


for pair = 1:23


% load emotional sharing condition
eeg_sub_1 = pop_loadset('filename',sprintf('hyper_cleaned_SNS_%s%s_%s%s_%s_ES_sub_1.set',cell2mat(pairs_A(pair)),list_of_files(pair).name(22), cell2mat(pairs_B(pair)),list_of_files(pair).name(27),list_of_files(pair).name(29)), 'check', 'off', 'loadmode', 'info');
eeg_sub_2 = pop_loadset('filename',sprintf('hyper_cleaned_SNS_%s%s_%s%s_%s_ES_sub_2.set',cell2mat(pairs_A(pair)),list_of_files(pair).name(22), cell2mat(pairs_B(pair)),list_of_files(pair).name(27),list_of_files(pair).name(29)), 'check', 'off', 'loadmode', 'info');

if eeg_sub_1.setname(22) == 'S'
    eeg_speaker_e = eeg_sub_1;
    eeg_listener_e = eeg_sub_2;
elseif eeg_sub_1.setname(22) == 'L'
    eeg_listener_e = eeg_sub_1;
    eeg_speaker_e = eeg_sub_2;
end




% load neutral sharing condition
eeg_sub_1 = pop_loadset('filename',sprintf('hyper_cleaned_SNS_%s%s_%s%s_%s_NS_sub_1.set',cell2mat(pairs_A(pair)),list_of_files(pair).name(22), cell2mat(pairs_B(pair)),list_of_files(pair).name(27),list_of_files(pair).name(29)), 'check', 'off', 'loadmode', 'info');
eeg_sub_2 = pop_loadset('filename',sprintf('hyper_cleaned_SNS_%s%s_%s%s_%s_NS_sub_2.set',cell2mat(pairs_A(pair)),list_of_files(pair).name(22), cell2mat(pairs_B(pair)),list_of_files(pair).name(27),list_of_files(pair).name(29)), 'check', 'off', 'loadmode', 'info');

if eeg_sub_1.setname(22) == 'S'
    eeg_speaker_n = eeg_sub_1;
    eeg_listener_n = eeg_sub_2;
elseif eeg_sub_1.setname(22) == 'L'
    eeg_listener_n = eeg_sub_1;
    eeg_speaker_n = eeg_sub_2;
end




npnts_e = length(eeg_speaker_e.data);
npnts_n = length(eeg_speaker_n.data);



hz_e = linspace(0,eeg_speaker_e.srate/2,floor(npnts_e/2)+1);
hz_n = linspace(0,eeg_speaker_n.srate/2,floor(npnts_n/2)+1);


chanpower_speaker_e = (2 *abs(fft(eeg_speaker_e.data,[],2)/npnts_e)).^2;
chanpower_listener_e = (2 *abs(fft(eeg_listener_e.data,[],2)/npnts_e)).^2;

chanpower_speaker_n = (2 *abs(fft(eeg_speaker_n.data,[],2)/npnts_n)).^2;
chanpower_listener_n = (2 *abs(fft(eeg_listener_n.data,[],2)/npnts_n)).^2;




thetaband = [3 8];
alphaband = [8 12];
betaband = [16 30];
gammaband = [30 45];

freqidx_e_theta = dsearchn(hz_e', thetaband');
freqidx_e_alpha = dsearchn(hz_e', alphaband');
freqidx_e_beta = dsearchn(hz_e', betaband');
freqidx_e_gamma = dsearchn(hz_e', gammaband');

freqidx_n_theta = dsearchn(hz_n', thetaband');
freqidx_n_alpha = dsearchn(hz_n', alphaband');
freqidx_n_beta = dsearchn(hz_n', betaband');
freqidx_n_gamma = dsearchn(hz_n', gammaband');


thetapower_speaker_e = mean(chanpower_speaker_e(:,freqidx_e_theta(1):freqidx_e_theta(2)),2);
thetapower_listener_e = mean(chanpower_listener_e(:,freqidx_e_theta(1):freqidx_e_theta(2)),2);
thetapower_speaker_n = mean(chanpower_speaker_n(:,freqidx_n_theta(1):freqidx_n_theta(2)),2);
thetapower_listener_n = mean(chanpower_listener_n(:,freqidx_n_theta(1):freqidx_n_theta(2)),2);

alphapower_speaker_e = mean(chanpower_speaker_e(:,freqidx_e_alpha(1):freqidx_e_alpha(2)),2);
alphapower_listener_e = mean(chanpower_listener_e(:,freqidx_e_alpha(1):freqidx_e_alpha(2)),2);
alphapower_speaker_n = mean(chanpower_speaker_n(:,freqidx_n_alpha(1):freqidx_n_alpha(2)),2);
alphapower_listener_n = mean(chanpower_listener_n(:,freqidx_n_alpha(1):freqidx_n_alpha(2)),2);

betapower_speaker_e = mean(chanpower_speaker_e(:,freqidx_e_beta(1):freqidx_e_beta(2)),2);
betapower_listener_e = mean(chanpower_listener_e(:,freqidx_e_beta(1):freqidx_e_beta(2)),2);
betapower_speaker_n = mean(chanpower_speaker_n(:,freqidx_n_beta(1):freqidx_n_beta(2)),2);
betapower_listener_n = mean(chanpower_listener_n(:,freqidx_n_beta(1):freqidx_n_beta(2)),2);

gammapower_speaker_e = mean(chanpower_speaker_e(:,freqidx_e_gamma(1):freqidx_e_gamma(2)),2);
gammapower_listener_e = mean(chanpower_listener_e(:,freqidx_e_gamma(1):freqidx_e_gamma(2)),2);
gammapower_speaker_n = mean(chanpower_speaker_n(:,freqidx_n_gamma(1):freqidx_n_gamma(2)),2);
gammapower_listener_n = mean(chanpower_listener_n(:,freqidx_n_gamma(1):freqidx_n_gamma(2)),2);


theta_speakers_e(:,pair) = thetapower_speaker_e;
alpha_speakers_e(:,pair) = alphapower_speaker_e;
beta_speakers_e(:,pair) = betapower_speaker_e;
gamma_speakers_e(:,pair) = gammapower_speaker_e;


theta_speakers_n(:,pair) = thetapower_speaker_n;
alpha_speakers_n(:,pair) = alphapower_speaker_n;
beta_speakers_n(:,pair) = betapower_speaker_n;
gamma_speakers_n(:,pair) = gammapower_speaker_n;


theta_listeners_e(:,pair) = thetapower_listener_e;
alpha_listeners_e(:,pair) = alphapower_listener_e;
beta_listeners_e(:,pair) = betapower_listener_e;
gamma_listeners_e(:,pair) = gammapower_listener_e;


theta_listeners_n(:,pair) = thetapower_listener_n;
alpha_listeners_n(:,pair) = alphapower_listener_n;
beta_listeners_n(:,pair) = betapower_listener_n;
gamma_listeners_n(:,pair) = gammapower_listener_n;





theta_freq = [thetapower_speaker_e thetapower_listener_e thetapower_speaker_n thetapower_listener_n];
bottom_theta = min(min(theta_freq));
top_theta = max(max(theta_freq));

alpha_freq = [alphapower_speaker_e alphapower_listener_e alphapower_speaker_n alphapower_listener_n];
bottom_alpha = min(min(alpha_freq));
top_alpha = max(max(alpha_freq));

beta_freq = [betapower_speaker_e betapower_listener_e betapower_speaker_n betapower_listener_n];
bottom_beta = min(min(beta_freq));
top_beta = max(max(beta_freq));

gamma_freq = [gammapower_speaker_e gammapower_listener_e gammapower_speaker_n gammapower_listener_n];
bottom_gamma = min(min(gamma_freq));
top_gamma = max(max(gamma_freq));



figure()

subplot(4,4,1)
topoplotIndie(thetapower_speaker_e,eeg_speaker_e.chanlocs, 'numcontour',0)
caxis manual
caxis([bottom_theta top_theta]);
colorbar;
title('Speaker Emotional Theta')

subplot(4,4,2)
topoplotIndie(thetapower_speaker_n,eeg_speaker_n.chanlocs, 'numcontour',0)
caxis manual
caxis([bottom_theta top_theta]);
colorbar;
title('Speaker Neutral Theta')

subplot(4,4,3)
topoplotIndie(thetapower_listener_e,eeg_speaker_e.chanlocs, 'numcontour',0)
caxis manual
caxis([bottom_theta top_theta]);
colorbar;
title('Listener Emotional Theta')

subplot(4,4,4)
topoplotIndie(thetapower_listener_n,eeg_speaker_n.chanlocs, 'numcontour',0)
caxis manual
caxis([bottom_theta top_theta]);
colorbar;
title('Listener Neutral Theta')

subplot(4,4,5)
topoplotIndie(alphapower_speaker_e,eeg_speaker_e.chanlocs, 'numcontour',0)
caxis manual
caxis([bottom_alpha top_alpha]);
colorbar;
title('Speaker Emotional Alpha')

subplot(4,4,6)
topoplotIndie(alphapower_speaker_n,eeg_speaker_n.chanlocs, 'numcontour',0)
caxis manual
caxis([bottom_alpha top_alpha]);
colorbar;
title('Speaker Neutral Alpha')

subplot(4,4,7)
topoplotIndie(alphapower_listener_e,eeg_speaker_e.chanlocs, 'numcontour',0)
caxis manual
caxis([bottom_alpha top_alpha]);
colorbar;
title('Listener Emotional Alpha')

subplot(4,4,8)
topoplotIndie(alphapower_listener_n,eeg_speaker_n.chanlocs, 'numcontour',0)
caxis manual
caxis([bottom_alpha top_alpha]);
colorbar;
title('Listener Neutral Alpha')

subplot(4,4,9)
topoplotIndie(betapower_speaker_e,eeg_speaker_e.chanlocs, 'numcontour',0)
caxis manual
caxis([bottom_beta top_beta]);
colorbar;
title('Speaker Emotional Beta')

subplot(4,4,10)
topoplotIndie(betapower_speaker_n,eeg_speaker_n.chanlocs, 'numcontour',0)
caxis manual
caxis([bottom_beta top_beta]);
colorbar;
title('Speaker Neutral Beta')

subplot(4,4,11)
topoplotIndie(betapower_listener_e,eeg_speaker_e.chanlocs, 'numcontour',0)
caxis manual
caxis([bottom_beta top_beta]);
colorbar;
title('Listener Emotional Beta')

subplot(4,4,12)
topoplotIndie(betapower_listener_n,eeg_speaker_n.chanlocs, 'numcontour',0)
caxis manual
caxis([bottom_beta top_beta]);
colorbar;
title('Listener Neutral Beta')


subplot(4,4,13)
topoplotIndie(gammapower_speaker_e,eeg_speaker_e.chanlocs, 'numcontour',0)
caxis manual
caxis([bottom_gamma top_gamma]);
colorbar;
title('Speaker Emotional Gamma')

subplot(4,4,14)
topoplotIndie(gammapower_speaker_n,eeg_speaker_n.chanlocs, 'numcontour',0)
caxis manual
caxis([bottom_gamma top_gamma]);
colorbar;
title('Speaker Neutral Gamma')

subplot(4,4,15)
topoplotIndie(gammapower_listener_e,eeg_speaker_e.chanlocs, 'numcontour',0)
caxis manual
caxis([bottom_gamma top_gamma]);
colorbar;
title('Listener Emotional Gamma')

subplot(4,4,16)
topoplotIndie(gammapower_listener_n,eeg_speaker_n.chanlocs, 'numcontour',0)
caxis manual
caxis([bottom_gamma top_gamma]);
colorbar;
title('Listener Neutral Gamma')

colormap parula
set(gcf,'Position',[50 50 900 900])

cd D:\Dropbox\Synchrony_Adam\Figures\Power_analysis
saveas(gcf,sprintf('Pair_%s.jpg', eeg_listener_n.setname(15:27)))



end

theta_speakers_e = mean(theta_speakers_e,2);
alpha_speakers_e = mean(alpha_speakers_e,2);
beta_speakers_e = mean(beta_speakers_e,2);
gamma_speakers_e = mean(gamma_speakers_e,2);

theta_speakers_n = mean(theta_speakers_n,2);
alpha_speakers_n = mean(alpha_speakers_n,2);
beta_speakers_n = mean(beta_speakers_n,2);
gamma_speakers_n = mean(gamma_speakers_n,2);

theta_listeners_e = mean(theta_listeners_e,2);
alpha_listeners_e = mean(alpha_listeners_e,2);
beta_listeners_e = mean(beta_listeners_e,2);
gamma_listeners_e = mean(gamma_listeners_e,2);

theta_listeners_n = mean(theta_listeners_n,2);
alpha_listeners_n = mean(alpha_listeners_n,2);
beta_listeners_n = mean(beta_listeners_n,2);
gamma_listeners_n = mean(gamma_listeners_n,2);



theta_freq = [theta_speakers_e theta_listeners_e theta_speakers_n theta_listeners_n];
bottom_theta = min(min(theta_freq));
top_theta = max(max(theta_freq));

alpha_freq = [alpha_speakers_e alpha_listeners_e alpha_speakers_n alpha_listeners_n];
bottom_alpha = min(min(alpha_freq));
top_alpha = max(max(alpha_freq));

beta_freq = [beta_speakers_e beta_listeners_e beta_speakers_n beta_listeners_n];
bottom_beta = min(min(beta_freq));
top_beta = max(max(beta_freq));

gamma_freq = [gamma_speakers_e gamma_listeners_e gamma_speakers_n gamma_listeners_n];
bottom_gamma = min(min(gamma_freq));
top_gamma = max(max(gamma_freq));


figure()



subplot(4,4,1)
topoplotIndie(theta_speakers_e,eeg_speaker_e.chanlocs, 'numcontour',0)
caxis manual
caxis([bottom_theta top_theta]);
colorbar;
title('Speaker Emotional Theta')

subplot(4,4,2)
topoplotIndie(theta_speakers_n,eeg_speaker_n.chanlocs, 'numcontour',0)
caxis manual
caxis([bottom_theta top_theta]);
colorbar;
title('Speaker Neutral Theta')

subplot(4,4,3)
topoplotIndie(theta_listeners_e,eeg_speaker_e.chanlocs, 'numcontour',0)
caxis manual
caxis([bottom_theta top_theta]);
colorbar;
title('Listener Emotional Theta')

subplot(4,4,4)
topoplotIndie(theta_listeners_n,eeg_speaker_n.chanlocs, 'numcontour',0)
caxis manual
caxis([bottom_theta top_theta]);
colorbar;
title('Listener Neutral Theta')

subplot(4,4,5)
topoplotIndie(alpha_speakers_e,eeg_speaker_e.chanlocs, 'numcontour',0)
caxis manual
caxis([bottom_alpha top_alpha]);
colorbar;
title('Speaker Emotional Alpha')

subplot(4,4,6)
topoplotIndie(alpha_speakers_n,eeg_speaker_n.chanlocs, 'numcontour',0)
caxis manual
caxis([bottom_alpha top_alpha]);
colorbar;
title('Speaker Neutral Alpha')

subplot(4,4,7)
topoplotIndie(alpha_listeners_e,eeg_speaker_e.chanlocs, 'numcontour',0)
caxis manual
caxis([bottom_alpha top_alpha]);
colorbar;
title('Listener Emotional Alpha')

subplot(4,4,8)
topoplotIndie(alpha_listeners_n,eeg_speaker_n.chanlocs, 'numcontour',0)
caxis manual
caxis([bottom_alpha top_alpha]);
colorbar;
title('Listener Neutral Alpha')

subplot(4,4,9)
topoplotIndie(beta_speakers_e,eeg_speaker_e.chanlocs, 'numcontour',0)
caxis manual
caxis([bottom_beta top_beta]);
colorbar;
title('Speaker Emotional Beta')

subplot(4,4,10)
topoplotIndie(beta_speakers_n,eeg_speaker_n.chanlocs, 'numcontour',0)
caxis manual
caxis([bottom_beta top_beta]);
colorbar;
title('Speaker Neutral Beta')

subplot(4,4,11)
topoplotIndie(beta_listeners_e,eeg_speaker_e.chanlocs, 'numcontour',0)
caxis manual
caxis([bottom_beta top_beta]);
colorbar;
title('Listener Emotional Beta')

subplot(4,4,12)
topoplotIndie(beta_listeners_n,eeg_speaker_n.chanlocs, 'numcontour',0)
caxis manual
caxis([bottom_beta top_beta]);
colorbar;
title('Listener Neutral Beta')


subplot(4,4,13)
topoplotIndie(gamma_speakers_e,eeg_speaker_e.chanlocs, 'numcontour',0)
caxis manual
caxis([bottom_gamma top_gamma]);
colorbar;
title('Speaker Emotional Gamma')

subplot(4,4,14)
topoplotIndie(gamma_speakers_n,eeg_speaker_n.chanlocs, 'numcontour',0)
caxis manual
caxis([bottom_gamma top_gamma]);
colorbar;
title('Speaker Neutral Gamma')

subplot(4,4,15)
topoplotIndie(gamma_listeners_e,eeg_speaker_e.chanlocs, 'numcontour',0)
caxis manual
caxis([bottom_gamma top_gamma]);
colorbar;
title('Listener Emotional Gamma')

subplot(4,4,16)
topoplotIndie(gamma_listeners_n,eeg_speaker_n.chanlocs, 'numcontour',0)
caxis manual
caxis([bottom_gamma top_gamma]);
colorbar;
title('Listener Neutral Gamma')

colormap parula
set(gcf,'Position',[50 50 900 900])

cd D:\Dropbox\Synchrony_Adam\Figures\Power_analysis
saveas(gcf,'avg_power.jpg')

