%% creates struct with power-spectral-density(over time) channel-frequency-matrix 
% for each subject/role/condition

%% Load data
% through helper skript
help_datacollector;

%% Poweranalysis  

% how many freqs to analyse
nfreqs = 45;

% create struct and fields
Power_mat = struct();
Power_mat.subj = [];
Power_mat.role = [];
Power_mat.cond = [];
Power_mat.power = [];


% loop over recordings
for i = 1:numel(list_of_files)
    % load next file
    EEG = pop_loadset('filename', list_of_files(i).name);
    %EEG = eeg_epoch2continuous(EEG); % change to continouous
    
    % get and save subject information
    [subj, role, cond] = help_subjectinfo(EEG.setname);
    Power_mat(i).subj = subj;
    Power_mat(i).role = role;
    Power_mat(i).cond = cond;
    
    
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

% for i=1:370
% figure(i), clf
% plot(Power_mat(i).hz,Power_mat(i).power,'linew',2)
% xlabel('Frequency (Hz)'), ylabel('Power (\muV)')
% set(gca,'xlim',[0 30])
% title(sprintf('Subject %s Role %s Condition %s', Power_mat(i).subj, Power_mat(i).role, Power_mat(i).cond))
% end
