%% creates struct with power(over time) channel-frequency-matrix 
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
    EEG = pop_loadset('filename', list_of_files(i).name,'verbose','off');
    
    % get and save subject information
    [subj, role, cond] = help_subjectinfo(EEG.setname);
    Power_mat(i).subj = subj;
    Power_mat(i).role = role;
    Power_mat(i).cond = cond;
    
    % calculate power for each channel and frequency
    power = zeros(EEG.nbchan,nfreqs);
    for ch = 1:EEG.nbchan
        [spectra, freqs] = spectopo(EEG.data(ch,:,:),0,EEG.srate,'freqrange',[0 nfreqs],'plot','off','verbose','off');
        % only take the specified n freqs
        spectra = spectra(1:nfreqs);
        freqs = freqs(1:nfreqs);
        %save power of each channel
        power(ch,:) = spectra;
    end
    
    % save power/freq matrix in struct
    Power_mat(i).power = power;
    
    % display progress (0 to 1)
    disp(i/numel(list_of_files));
end
