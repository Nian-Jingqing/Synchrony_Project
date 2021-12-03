%% creates struct with power-spectral-density(over time) channel-frequency-matrix 
% for each subject/role/condition

%% Load data
% through helper skript
help_datacollector;

%% Poweranalysis  

% how many freqs to analyse
nfreqs = 45;

% create struct and fields
PSD_mat = struct();
PSD_mat.subj = [];
PSD_mat.role = [];
PSD_mat.cond = [];
PSD_mat.power = [];


% loop over recordings
for i = 1:numel(list_of_files)
    % load next file
    EEG = pop_loadset('filename', list_of_files(i).name);
    %EEG = eeg_epoch2continuous(EEG); % change to continouous
    
    % get and save subject information
    [subj, role, cond] = help_subjectinfo(EEG.setname);
    PSD_mat(i).subj = subj;
    PSD_mat(i).role = role;
    PSD_mat(i).cond = cond;
    
    
    chanpowr = ( 2*abs( fft(EEG.data,[],2) )/EEG.pnts ).^2;
    chanpowr = mean(chanpowr,3);
    hz = linspace(0,EEG.srate/2,floor(EEG.pnts/2)+1);
    

%     % calculate power for each channel and frequency
%     power = zeros(EEG.nbchan,nfreqs);
%     for ch = 1:EEG.nbchan
%         %[spectra, freqs] = spectopo(EEG.data(ch,:,:),0,EEG.srate,'freqrange',[0 nfreqs],'plot','off','verbose','off');
%         powspectAverage  = fft(squeeze(mean(EEG.data(ch,:,:),3)))/length(EEG.times);
%         powspectAverage  = 2*abs(powspectAverage);
%         powspectAverage = powspectAverage(1:nfreqs);
%         
%         % only take the specified n freqs
%         %spectra = spectra(1:nfreqs);
%         %freqs = freqs(1:nfreqs);
%         %save power of each channel
%         power(ch,:) = powspectAverage;
%     end
    
    % save power/freq matrix in struct
    Power_mat(i).power =  chanpowr(:,1:find(hz == 45));
    Power_mat(i).hz = hz(1:find(hz == 45));
    %plot(hz(1:find(hz == 45)), Power_mat(2).power')
    % display progress (0 to 1)
    disp(i/numel(list_of_files));
end


%% plot power for each pair

cd D:\Dropbox\Projects\Emotional_Sharing_EEG\Figures\Power_Pairs

pairs = [0 linspace(1,35,35)*10];

for pair=1:36
figure(pair), clf
%max_pair = [];
for i=1:10
subplot(5,2,i);
plot(Power_mat(i+pairs(pair)).hz,Power_mat(i+pairs(pair)).power,'linew',2)
xlabel('Frequency (Hz)'), ylabel('Power (\muV)')
set(gca,'xlim',[0 45])
title(sprintf('Subject %s Role %s Condition %s', PSD_mat(i+pairs(pair)).subj, PSD_mat(i+pairs(pair)).role, PSD_mat(i+pairs(pair)).cond))
%max_file = max(max(Power_mat(i).power));
%max_pair = [ max_pair max_file];
%mygca(i) = gca;
end
saveas(gcf,sprintf('Pair_%d.jpg',pair))
%set(mygca, 'Ylim', [0 max(max_pair)])
end