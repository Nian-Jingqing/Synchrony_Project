%% Set Parameters

% samplerate
srate = 500;

% frequency parameters - create evenly spaced vector
min_freq =  2; % in Hz
max_freq = 45; % in HZ
num_freq = 44; % in count

frex = linspace(min_freq,max_freq,num_freq);

% For Complex Morlet Wavelet: create time vector from -1 to +1 
% length = twice sampling rate
time = (0:2*srate)/srate;
time = time - mean(time); 

%% Load data
help_datacollector;
help_chose_analysisfolder;

%% TimeFrequency Extraction

% Loop over each file
for file = 1:length(list_of_files)
    
    % load next file set
    EEG = pop_loadset('filename', list_of_files(file).name,'verbose','off');

    % it is possible that we have to concatenate epochs for this
    % here is example how
    %
    % concanate data
    
   

    samples = size(EEG.data,2)*size(EEG.data,3);

    % empty matrix for electrode x frequency x sample
    tf_elec = zeros(EEG.nbchan, num_freq, samples);

    % loop over electrodes
    for electrode = 1:EEG.nbchan
        data_e = EEG.data(electrode,:);

        % reshape the data to be 1D
        dataR = reshape(data_e,1,[]);

        % Step 1: N's of convolution
        ndata = length(dataR); % note the different variable name!
        nkern = length(time); %
        nConv = ndata + nkern - 2; 
        halfK = floor(nkern/2);

         % initialize TF matrix
        tf = zeros(num_freq,samples);
        
        % Step 2: FFT of Data
        dataX = fft( dataR,nConv );

        % extract tf for each frequency
        for f_idx=1:num_freq

            csine  = exp(1i*2*pi*frex(f_idx)*time); % complex sine wave
            gaus_win = exp( -4*log(2)*time.^2 / .3^2 ); % gaussian window - updated from cohen 2019

            cmw = csine .* gaus_win; % resulting complex morlet wavelet:

            cmwX = fft(cmw,nConv); % FFT of wavelet
            cmwX = cmwX./max(cmwX); % ampl. normalization

            % Finish convolution
            as = ifft( dataX .* cmwX );
            as = as(halfK+1:end-halfK+1); % cutoff wavelet overhang
            as = reshape(as,size(data_e,1),size(data_e,2)); 

            % average over trials, save in freq_matrix
            tf(f_idx,:) = as;
        end
       
        % save all tf of all frequencies in electrode_matrix
        tf_elec(electrode,:,:) = tf;
        
    end
    
    % get subjectinfos
    [subj,role,cond] = help_subjectinfo(EEG.setname);
    % save tf of all electrodes
    filename = sprintf('tf_subject%s_condition%s_role%s.mat',subj,role,cond);
    fullfilename = fullfile(filepath,filename);
    save(fullfilename,'tf_elec','-v7.3'); % v7.3 for larger .m files
    
    % check progress
    fprintf('file %d of %d done',file,length(list_of_files));
    
end
    
%% TODO:

% Amplitude = abs(_)
% Power = abs(_).^2
% Phase = angle(_)
