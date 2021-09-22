%% Load Power matrix of electrodes vs frequencies (45)

power_analysis_til

%% Plotting avg of subjects per role
% collect all speaker/listener files
Power_speaker = Power_mat(strcmp({Power_mat.role}, 'S'));
Power_listener = Power_mat(strcmp({Power_mat.role}, 'L'));

% calculate avg speaker power matrix
speaker_cat = cat(3,Power_speaker.power);
speaker_avg = mean(speaker_cat,3);
% calculate avg listener power matrix
listener_cat = cat(3,Power_listener.power);
listener_avg = mean(listener_cat,3);

%calculate colorbar limits
allavg_cat = cat(1,speaker_avg, listener_avg);
cmin = min(allavg_cat,[],'all');
cmax = max(allavg_cat,[],'all');
clims = [cmin cmax];

% Plotting
figure();
subplot(1,2,1);
imagesc(speaker_avg,clims);
title('Role = speaker');
xlabel('freq (Hz)');
ylabel('electrode');

cb=colorbar;
cb.Label.String = 'Log Power Spectral Density 10*log_{10}(\muV^{2}/Hz)';


subplot(1,2,2);
imagesc(listener_avg,clims);
title('Role = listener');
xlabel('freq (Hz)');
ylabel('electrode');

cb=colorbar;
cb.Label.String = 'Log Power Spectral Density 10*log_{10}(\muV^{2}/Hz)';

