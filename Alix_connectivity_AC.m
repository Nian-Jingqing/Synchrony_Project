%% Step-by-step analysis plan: 
   % info data structure
   % load EEGLAB and data
   % set up parameters for analyses
   % time frequency analysis (by looping over channels and frequencies)
        % plotting t-f results
   % connectivity analysis
        % amplitude + plotting
        % phase + plotting
    
%% Info about data structure 
   % sampling rate (datapoints points in 1 sec) = 500
   % number of seconds = 298
   % number of data points = 500*298 = 149000
   % number of channels = 24
   % data structure = channels x data points = 24 x 149000

%% Load EEGLAB and data

% Initialize EEGLAB
%addpath('/Users/AlixWeidema/Desktop/MATLAB/eeglab2021.0');
eeglab;

%%% STEP 1
% You need to start a loop here to loop over all dyads and conditions
% function sprintf() can help to manipulate iteratively string with
% filename used in pop_loadset
% everything that come next should be part of that loop

conditions = ['ES'; 'NS']; % ES = condition 1 and NS = condition 2

% create lists of dyad numbers
dyads_A = {'003' '005' '007' '009' '013' '015' '017' '019' '021' '023' '025' '027' '029' '031' '037' '039' '041' '045' '047' '049' '051' '053' '055' '057' '059' '063' '065' '069' '073' '075' '079' '081' '085'};
dyads_B = {'004' '006' '008' '010' '014' '016' '018' '020' '022' '024' '026' '028' '030' '032' '038' '040' '042' '046' '048' '050' '052' '054' '056' '058' '060' '064' '066' '070' '074' '076' '080' '082' '086'};

% change directory to the right folder
%cd '/Users/AlixWeidema/Dropbox/hyper_cleaned'


for dyadi = 1:33
    
   for conditioni = 1:2
      
      cd D:\Dropbox\Synchrony_Adam\EEG_Data\Preprocessed\hyper_cleaned
      % subjects 1
      % create a list of subject 1 files (does not matter which condition)
      subject = 1     
      list_of_files = dir('**/*ES_sub_1.set'); 
      filename = sprintf('hyper_cleaned_SNS_%s%s_%s%s_%s_%s%s_sub_%d.set', cell2mat(dyads_A(dyadi)), list_of_files(dyadi).name(22), cell2mat(dyads_B(dyadi)), list_of_files(dyadi).name(27), list_of_files(dyadi).name(29), conditions(conditioni), conditions(conditioni,2), subject); 
      data_sub_A = pop_loadset('filename', filename, 'check', 'off', 'loadmode', 'info'); 
      
      % subjects 2
      % create a list of subject 2 files
      subject = 2     
      list_of_files = dir('**/*ES_sub_2.set'); 
      filename = sprintf('hyper_cleaned_SNS_%s%s_%s%s_%s_%s%s_sub_%d.set', cell2mat(dyads_A(dyadi)), list_of_files(dyadi).name(22), cell2mat(dyads_B(dyadi)), list_of_files(dyadi).name(27), list_of_files(dyadi).name(29), conditions(conditioni), conditions(conditioni,2), subject); 
      data_sub_B = pop_loadset('filename', filename, 'check', 'off', 'loadmode', 'info'); 

%% set up parameters for analyses

%%% STEP 2 
% i commented out many lines here. They are not required. Nothing to do for
% you. just fyi

% % connectivity parameters
% channel_A = 'F4'; % (for now, I chose F4)
% timewin_A = [ 0 1000 ]; % in ms (I though 1-1000 because we want to compute connectivity 
% % by sliding a time window of 1 sec over the spectral signal)
% freqwin_A = [ 8 13 ]; % in Hz (for now, I chose alpha)
% 
% channel_B = 'F4';
% timewin_B = [ 0 1000]; % in ms
% freqwin_B = [ 8 13 ]; % in Hz

% frequency parameters for time-frequency analysis (1-40 Hz in steps of 1
% Hz)

        min_freq =  1;
        max_freq = 40;
        num_freq = 40;
        frex = logspace(log10(min_freq),log10(max_freq),num_freq); % logarithmic distribution of frequencies!

% % convert connectivity parameters to indices
% chanAidx = strcmpi({data_sub_A.chanlocs.labels},channel_A);
% timeAidx = dsearchn(data_sub_A.times',timewin_A');
% freqAidx = dsearchn(frex',freqwin_A');
% 
% chanBidx = strcmpi({data_sub_B.chanlocs.labels},channel_B);
% timeBidx = dsearchn(data_sub_B.times',timewin_B');
% freqBidx = dsearchn(frex',freqwin_B');

% wavelet parameters 
        range_cycles = [ 4 10 ]; % What values should I use here? 
        s = logspace(log10(range_cycles(1)),log10(range_cycles(end)),num_freq) ./ (2*pi*frex);
        srate = data_sub_A.srate;
        wavtime = -2:1/srate:2;
        half_wave = (length(wavtime)-1)/2; % define this to later cut 
        % 1/2 of the length of the wavelet from the beginning and from the end

% convolution parameters
        nWave = length(wavtime);
        nData = length(data_sub_A.data);
        nConv = nWave + nData - 1; % this is N + M - 1 length convolution! (note 
        % that the "N" parameter is the length of convolution, not the length
        % of the original signals)

        % initialize output t-f data for both phase and amplitude results (channels x freq x data points)
        tf_data_sub_A_phase = zeros(data_sub_A.nbchan,num_freq, length(data_sub_A.data));
        tf_data_sub_A_amplitude = zeros(data_sub_A.nbchan,num_freq, length(data_sub_A.data));

        tf_data_sub_B_phase = zeros(data_sub_A.nbchan,num_freq, length(data_sub_A.data));
        tf_data_sub_B_amplitude = zeros(data_sub_A.nbchan,num_freq, length(data_sub_A.data));


        %% TIME FREQUENCY ANALYSIS

        for chani = 1:24 % loop over all channels

            % FFT of data
            data_sub_A_X = fft(data_sub_A.data(chani,:),nConv);
            data_sub_B_X = fft(data_sub_B.data(chani,:),nConv);
            for fi = 1:length(frex) % loop over all frequencies
                % create complex morlet wavelet and get its FFT
                wavelet  = exp(2*1i*pi*frex(fi).*wavtime) .* exp(-wavtime.^2./(2*s(fi)^2));
                waveletX = fft(wavelet,nConv);
                waveletX = waveletX ./ max(waveletX);

                % convolution
                as_sub_A = ifft(waveletX .* data_sub_A_X); % (as = analytic signal)
                as_sub_A = as_sub_A(half_wave+1:end-half_wave); % cut 1/2 of the length of the wavelet
                % from the beginning and from the end to go back to length of original signal

                as_sub_B = ifft(waveletX .* data_sub_B_X);
                as_sub_B = as_sub_B(half_wave+1:end-half_wave);

                % PHASE 

                % collect phase data 
                phase_data_sub_A = angle(as_sub_A);
                phase_data_sub_B = angle(as_sub_B);

                % put phase data into tf matrix I initialized before
                tf_data_sub_A_phase(chani,fi,:) = phase_data_sub_A;
                tf_data_sub_B_phase(chani,fi,:) = phase_data_sub_B;

                % AMPLITUDE

                % Collect real data
                real_data_sub_A = real(as_sub_A);
                real_data_sub_B = real(as_sub_B);

                % put amplitude data into tf matrix I initialized before
                % 24 channels x 40 frequencies x 149000 data points
                tf_data_sub_A_amplitude(chani,fi,:) = real_data_sub_A;
                tf_data_sub_B_amplitude(chani,fi,:) = real_data_sub_B;
            end


        end

        %%% STEP 3
        % these loop will calculate power (power is squared amplitude) correlation
        % between brain1 to brain2 --- this loop took around a minute on my laptop
        % so don't be surprised if it takes a bit of time


        power_calc = zeros(num_freq,24,24);

        for frequencies = 1:num_freq
            power_freq = zeros(24,24);
            for electrodes_sub1 = 1:24
                data1 = squeeze(abs(tf_data_sub_A_amplitude(electrodes_sub1,frequencies,:)).^2);
                for electrodes_sub2 = 1:24
                    data2 = squeeze(abs(tf_data_sub_B_amplitude(electrodes_sub2,frequencies,:)).^2);
                    power_corr = corrcoef(data1,data2);
                    power_freq(electrodes_sub1,electrodes_sub2) = power_corr(2);
                end
            end
            power_calc(frequencies,:,:) = power_freq;
        end

        %%% STEP 4
        % similar loop to calculate angular difference between phases

        angle_diff = zeros(num_freq,24,24);

        n = size(tf_data_sub_A_phase,3);
        trials = n/500;
        trial_size = 500;

        for frequencies = 1:num_freq
            angle_diff_freq = zeros(24,24);
            for electrodes_sub1 = 1:24
                data1 = squeeze(tf_data_sub_A_phase(electrodes_sub1,frequencies,:));
                for electrodes_sub2 = 1:24
                    data2 = squeeze(tf_data_sub_B_phase(electrodes_sub2,frequencies,:));
                    data_trial_1 = mat2cell(data1,diff([0:trial_size:n-1,n]));
                    data_trial_2 = mat2cell(data2,diff([0:trial_size:n-1,n]));
                    trials_angle_diff = zeros(trials,1);
                    for trial = 1:trials
                        trials_angle_diff(trial) = mean(angdiff(data_trial_1{trial,1}-data_trial_2{trial,1}));
                    end

                    angle_diff_freq(electrodes_sub1,electrodes_sub2) = mean(trials_angle_diff);
                end
            end
            angle_diff(frequencies,:,:) = angle_diff_freq;
        end
     
%%% STEP 5
% save two variables:
% 1.power_calc
% 2. angle_diff

% add dyad number and condition in the name, again here function sprintf
% can be helpful

% change directory to the right folder (folder where I want to save)
cd D:\Dropbox\Synchrony_Adam\EEG_Data\TF_ALIX

% save files
save(sprintf('power_calc_dyad%d_conditon%d', dyadi, conditioni), 'power_calc');
save(sprintf('angle_diff_dyad%d_conditon%d', dyadi, conditioni), 'angle_diff');

        
   end
end 
 

%% STATISTICS 

% change directory to the right folder
cd '/Users/AlixWeidema/Desktop/MATLAB/Thesis/Hyper cleaned data'

% load data for both conditions and both measures

% emotional condition (= condition 1)

% angle data
angle_diff_dyad1_ES = importdata('angle_diff_dyad1_conditon1.mat');
angle_diff_dyad2_ES = importdata('angle_diff_dyad2_conditon1.mat');
angle_diff_dyad3_ES = importdata('angle_diff_dyad3_conditon1.mat');
angle_diff_dyad4_ES = importdata('angle_diff_dyad4_conditon1.mat');
angle_diff_dyad5_ES = importdata('angle_diff_dyad5_conditon1.mat');
angle_diff_dyad6_ES = importdata('angle_diff_dyad6_conditon1.mat');
angle_diff_dyad7_ES = importdata('angle_diff_dyad7_conditon1.mat');
angle_diff_dyad8_ES = importdata('angle_diff_dyad8_conditon1.mat');
angle_diff_dyad9_ES = importdata('angle_diff_dyad9_conditon1.mat');
angle_diff_dyad10_ES = importdata('angle_diff_dyad10_conditon1.mat');
angle_diff_dyad11_ES = importdata('angle_diff_dyad11_conditon1.mat');
angle_diff_dyad12_ES = importdata('angle_diff_dyad12_conditon1.mat');
angle_diff_dyad13_ES = importdata('angle_diff_dyad13_conditon1.mat');
angle_diff_dyad14_ES = importdata('angle_diff_dyad14_conditon1.mat');
angle_diff_dyad15_ES = importdata('angle_diff_dyad15_conditon1.mat');
angle_diff_dyad16_ES = importdata('angle_diff_dyad16_conditon1.mat');
angle_diff_dyad17_ES = importdata('angle_diff_dyad17_conditon1.mat');
angle_diff_dyad18_ES = importdata('angle_diff_dyad18_conditon1.mat');
angle_diff_dyad19_ES = importdata('angle_diff_dyad19_conditon1.mat');
angle_diff_dyad20_ES = importdata('angle_diff_dyad20_conditon1.mat');
angle_diff_dyad21_ES = importdata('angle_diff_dyad21_conditon1.mat');
angle_diff_dyad22_ES = importdata('angle_diff_dyad22_conditon1.mat');
angle_diff_dyad23_ES = importdata('angle_diff_dyad23_conditon1.mat');

% power data
power_calc_dyad1_ES = importdata('power_calc_dyad1_conditon1.mat');
power_calc_dyad2_ES = importdata('power_calc_dyad2_conditon1.mat');
power_calc_dyad3_ES = importdata('power_calc_dyad3_conditon1.mat');
power_calc_dyad4_ES = importdata('power_calc_dyad4_conditon1.mat');
power_calc_dyad5_ES = importdata('power_calc_dyad5_conditon1.mat');
power_calc_dyad6_ES = importdata('power_calc_dyad6_conditon1.mat');
power_calc_dyad7_ES = importdata('power_calc_dyad7_conditon1.mat');
power_calc_dyad8_ES = importdata('power_calc_dyad8_conditon1.mat');
power_calc_dyad9_ES = importdata('power_calc_dyad9_conditon1.mat');
power_calc_dyad10_ES = importdata('power_calc_dyad10_conditon1.mat');
power_calc_dyad11_ES = importdata('power_calc_dyad11_conditon1.mat');
power_calc_dyad12_ES = importdata('power_calc_dyad12_conditon1.mat');
power_calc_dyad13_ES = importdata('power_calc_dyad13_conditon1.mat');
power_calc_dyad14_ES = importdata('power_calc_dyad14_conditon1.mat');
power_calc_dyad15_ES = importdata('power_calc_dyad15_conditon1.mat');
power_calc_dyad16_ES = importdata('power_calc_dyad16_conditon1.mat');
power_calc_dyad17_ES = importdata('power_calc_dyad17_conditon1.mat');
power_calc_dyad18_ES = importdata('power_calc_dyad18_conditon1.mat');
power_calc_dyad19_ES = importdata('power_calc_dyad19_conditon1.mat');
power_calc_dyad20_ES = importdata('power_calc_dyad20_conditon1.mat');
power_calc_dyad21_ES = importdata('power_calc_dyad21_conditon1.mat');
power_calc_dyad22_ES = importdata('power_calc_dyad22_conditon1.mat');
power_calc_dyad23_ES = importdata('power_calc_dyad23_conditon1.mat');

% neutral condition (= condition 2)

% angle data
angle_diff_dyad1_NS = importdata('angle_diff_dyad1_conditon2.mat');
angle_diff_dyad2_NS = importdata('angle_diff_dyad2_conditon2.mat');
angle_diff_dyad3_NS = importdata('angle_diff_dyad3_conditon2.mat');
angle_diff_dyad4_NS = importdata('angle_diff_dyad4_conditon2.mat');
angle_diff_dyad5_NS = importdata('angle_diff_dyad5_conditon2.mat');
angle_diff_dyad6_NS = importdata('angle_diff_dyad6_conditon2.mat');
angle_diff_dyad7_NS = importdata('angle_diff_dyad7_conditon2.mat');
angle_diff_dyad8_NS = importdata('angle_diff_dyad8_conditon2.mat');
angle_diff_dyad9_NS = importdata('angle_diff_dyad9_conditon2.mat');
angle_diff_dyad10_NS = importdata('angle_diff_dyad10_conditon2.mat');
angle_diff_dyad11_NS = importdata('angle_diff_dyad11_conditon2.mat');
angle_diff_dyad12_NS = importdata('angle_diff_dyad12_conditon2.mat');
angle_diff_dyad13_NS = importdata('angle_diff_dyad13_conditon2.mat');
angle_diff_dyad14_NS = importdata('angle_diff_dyad14_conditon2.mat');
angle_diff_dyad15_NS = importdata('angle_diff_dyad15_conditon2.mat');
angle_diff_dyad16_NS = importdata('angle_diff_dyad16_conditon2.mat');
angle_diff_dyad17_NS = importdata('angle_diff_dyad17_conditon2.mat');
angle_diff_dyad18_NS = importdata('angle_diff_dyad18_conditon2.mat');
angle_diff_dyad19_NS = importdata('angle_diff_dyad19_conditon2.mat');
angle_diff_dyad20_NS = importdata('angle_diff_dyad20_conditon2.mat');
angle_diff_dyad21_NS = importdata('angle_diff_dyad21_conditon2.mat');
angle_diff_dyad22_NS = importdata('angle_diff_dyad22_conditon2.mat');
angle_diff_dyad23_NS = importdata('angle_diff_dyad23_conditon2.mat');

% power data
power_calc_dyad1_NS = importdata('power_calc_dyad1_conditon2.mat');
power_calc_dyad2_NS = importdata('power_calc_dyad2_conditon2.mat');
power_calc_dyad3_NS = importdata('power_calc_dyad3_conditon2.mat');
power_calc_dyad4_NS = importdata('power_calc_dyad4_conditon2.mat');
power_calc_dyad5_NS = importdata('power_calc_dyad5_conditon2.mat');
power_calc_dyad6_NS = importdata('power_calc_dyad6_conditon2.mat');
power_calc_dyad7_NS = importdata('power_calc_dyad7_conditon2.mat');
power_calc_dyad8_NS = importdata('power_calc_dyad8_conditon2.mat');
power_calc_dyad9_NS = importdata('power_calc_dyad9_conditon2.mat');
power_calc_dyad10_NS = importdata('power_calc_dyad10_conditon2.mat');
power_calc_dyad11_NS = importdata('power_calc_dyad11_conditon2.mat');
power_calc_dyad12_NS = importdata('power_calc_dyad12_conditon2.mat');
power_calc_dyad13_NS = importdata('power_calc_dyad13_conditon2.mat');
power_calc_dyad14_NS = importdata('power_calc_dyad14_conditon2.mat');
power_calc_dyad15_NS = importdata('power_calc_dyad15_conditon2.mat');
power_calc_dyad16_NS = importdata('power_calc_dyad16_conditon2.mat');
power_calc_dyad17_NS = importdata('power_calc_dyad17_conditon2.mat');
power_calc_dyad18_NS = importdata('power_calc_dyad18_conditon2.mat');
power_calc_dyad19_NS = importdata('power_calc_dyad19_conditon2.mat');
power_calc_dyad20_NS = importdata('power_calc_dyad20_conditon2.mat');
power_calc_dyad21_NS = importdata('power_calc_dyad21_conditon2.mat');
power_calc_dyad22_NS = importdata('power_calc_dyad22_conditon2.mat');
power_calc_dyad23_NS = importdata('power_calc_dyad23_conditon2.mat');

% combine different files into single variables (4 in total)

% emotional condition (= condition 1)

% angle data 
angle_diff_ES = zeros(23, 40, 24, 24); % initialize variable

angle_diff_ES(1,:,:,:) = angle_diff_dyad1_ES;
angle_diff_ES(2,:,:,:) = angle_diff_dyad2_ES;
angle_diff_ES(3,:,:,:) = angle_diff_dyad3_ES;
angle_diff_ES(4,:,:,:) = angle_diff_dyad4_ES;
angle_diff_ES(5,:,:,:) = angle_diff_dyad5_ES;
angle_diff_ES(6,:,:,:) = angle_diff_dyad6_ES;
angle_diff_ES(7,:,:,:) = angle_diff_dyad7_ES;
angle_diff_ES(8,:,:,:) = angle_diff_dyad8_ES;
angle_diff_ES(9,:,:,:) = angle_diff_dyad9_ES;
angle_diff_ES(10,:,:,:) = angle_diff_dyad10_ES;
angle_diff_ES(11,:,:,:) = angle_diff_dyad11_ES;
angle_diff_ES(12,:,:,:) = angle_diff_dyad12_ES;
angle_diff_ES(13,:,:,:) = angle_diff_dyad13_ES;
angle_diff_ES(14,:,:,:) = angle_diff_dyad14_ES;
angle_diff_ES(15,:,:,:) = angle_diff_dyad15_ES;
angle_diff_ES(16,:,:,:) = angle_diff_dyad16_ES;
angle_diff_ES(17,:,:,:) = angle_diff_dyad17_ES;
angle_diff_ES(18,:,:,:) = angle_diff_dyad18_ES;
angle_diff_ES(19,:,:,:) = angle_diff_dyad19_ES;
angle_diff_ES(20,:,:,:) = angle_diff_dyad20_ES;
angle_diff_ES(21,:,:,:) = angle_diff_dyad21_ES;
angle_diff_ES(22,:,:,:) = angle_diff_dyad22_ES;
angle_diff_ES(23,:,:,:) = angle_diff_dyad23_ES;


% power data
power_calc_ES = zeros(23, 40, 24, 24); % initialize variable

power_calc_ES(1,:,:,:) = power_calc_dyad1_ES;
power_calc_ES(1,:,:,:) = power_calc_dyad1_ES;
power_calc_ES(2,:,:,:) = power_calc_dyad2_ES;
power_calc_ES(3,:,:,:) = power_calc_dyad3_ES;
power_calc_ES(4,:,:,:) = power_calc_dyad4_ES;
power_calc_ES(5,:,:,:) = power_calc_dyad5_ES;
power_calc_ES(6,:,:,:) = power_calc_dyad6_ES;
power_calc_ES(7,:,:,:) = power_calc_dyad7_ES;
power_calc_ES(8,:,:,:) = power_calc_dyad8_ES;
power_calc_ES(9,:,:,:) = power_calc_dyad9_ES;
power_calc_ES(10,:,:,:) = power_calc_dyad10_ES;
power_calc_ES(11,:,:,:) = power_calc_dyad11_ES;
power_calc_ES(12,:,:,:) = power_calc_dyad12_ES;
power_calc_ES(13,:,:,:) = power_calc_dyad13_ES;
power_calc_ES(14,:,:,:) = power_calc_dyad14_ES;
power_calc_ES(15,:,:,:) = power_calc_dyad15_ES;
power_calc_ES(16,:,:,:) = power_calc_dyad16_ES;
power_calc_ES(17,:,:,:) = power_calc_dyad17_ES;
power_calc_ES(18,:,:,:) = power_calc_dyad18_ES;
power_calc_ES(19,:,:,:) = power_calc_dyad19_ES;
power_calc_ES(20,:,:,:) = power_calc_dyad20_ES;
power_calc_ES(21,:,:,:) = power_calc_dyad21_ES;
power_calc_ES(22,:,:,:) = power_calc_dyad22_ES;
power_calc_ES(23,:,:,:) = power_calc_dyad23_ES;

% neutral condition (= condition 2)

% angle data
angle_diff_NS = zeros(23, 40, 24, 24); % initialize variable

angle_diff_NS(1,:,:,:) = angle_diff_dyad1_NS;
angle_diff_NS(2,:,:,:) = angle_diff_dyad2_NS;
angle_diff_NS(3,:,:,:) = angle_diff_dyad3_NS;
angle_diff_NS(4,:,:,:) = angle_diff_dyad4_NS;
angle_diff_NS(5,:,:,:) = angle_diff_dyad5_NS;
angle_diff_NS(6,:,:,:) = angle_diff_dyad6_NS;
angle_diff_NS(7,:,:,:) = angle_diff_dyad7_NS;
angle_diff_NS(8,:,:,:) = angle_diff_dyad8_NS;
angle_diff_NS(9,:,:,:) = angle_diff_dyad9_NS;
angle_diff_NS(10,:,:,:) = angle_diff_dyad10_NS;
angle_diff_NS(11,:,:,:) = angle_diff_dyad11_NS;
angle_diff_NS(12,:,:,:) = angle_diff_dyad12_NS;
angle_diff_NS(13,:,:,:) = angle_diff_dyad13_NS;
angle_diff_NS(14,:,:,:) = angle_diff_dyad14_NS;
angle_diff_NS(15,:,:,:) = angle_diff_dyad15_NS;
angle_diff_NS(16,:,:,:) = angle_diff_dyad16_NS;
angle_diff_NS(17,:,:,:) = angle_diff_dyad17_NS;
angle_diff_NS(18,:,:,:) = angle_diff_dyad18_NS;
angle_diff_NS(19,:,:,:) = angle_diff_dyad19_NS;
angle_diff_NS(20,:,:,:) = angle_diff_dyad20_NS;
angle_diff_NS(21,:,:,:) = angle_diff_dyad21_NS;
angle_diff_NS(22,:,:,:) = angle_diff_dyad22_NS;
angle_diff_NS(23,:,:,:) = angle_diff_dyad23_NS;

% power data 
power_calc_NS = zeros(23, 40, 24, 24); % initialize variable

power_calc_NS(1,:,:,:) = power_calc_dyad1_NS;
power_calc_NS(2,:,:,:) = power_calc_dyad2_NS;
power_calc_NS(3,:,:,:) = power_calc_dyad3_NS;
power_calc_NS(4,:,:,:) = power_calc_dyad4_NS;
power_calc_NS(5,:,:,:) = power_calc_dyad5_NS;
power_calc_NS(6,:,:,:) = power_calc_dyad6_NS;
power_calc_NS(7,:,:,:) = power_calc_dyad7_NS;
power_calc_NS(8,:,:,:) = power_calc_dyad8_NS;
power_calc_NS(9,:,:,:) = power_calc_dyad9_NS;
power_calc_NS(10,:,:,:) = power_calc_dyad10_NS;
power_calc_NS(11,:,:,:) = power_calc_dyad11_NS;
power_calc_NS(12,:,:,:) = power_calc_dyad12_NS;
power_calc_NS(13,:,:,:) = power_calc_dyad13_NS;
power_calc_NS(14,:,:,:) = power_calc_dyad14_NS;
power_calc_NS(15,:,:,:) = power_calc_dyad15_NS;
power_calc_NS(16,:,:,:) = power_calc_dyad16_NS;
power_calc_NS(17,:,:,:) = power_calc_dyad17_NS;
power_calc_NS(18,:,:,:) = power_calc_dyad18_NS;
power_calc_NS(19,:,:,:) = power_calc_dyad19_NS;
power_calc_NS(20,:,:,:) = power_calc_dyad20_NS;
power_calc_NS(21,:,:,:) = power_calc_dyad21_NS;
power_calc_NS(22,:,:,:) = power_calc_dyad22_NS;
power_calc_NS(23,:,:,:) = power_calc_dyad23_NS;

% frequency values (= repetition from earlier specified values)
 min_freq =  1;
 max_freq = 40;
 num_freq = 40;
 frex = logspace(log10(min_freq),log10(max_freq),num_freq); 

 
%% t-tests between emotional and neutral 

% angle
pvalues_angle_diff_ES_NS = zeros(40,24,24); % initialize 
tvalues_angle_diff_ES_NS = zeros(40,24,24); % initialize


for frequency = 1:num_freq
    for electrode_sub1 = 1:24
        for electrode_sub2 = 1:24
            [h,p,ci,stats] = ttest(angle_diff_ES(:,frequency,electrode_sub1,electrode_sub2),angle_diff_NS(:,frequency,electrode_sub1,electrode_sub2));
            pvalues_angle_diff_ES_NS(frequency,electrode_sub1,electrode_sub2) = p;
            tvalues_angle_diff_ES_NS(frequency,electrode_sub1,electrode_sub2) = stats.tstat;
        end
    end
end

% power
pvalues_power_calc_ES_NS = zeros(40,24,24); % initialize 
tvalues_power_calc_ES_NS = zeros(40,24,24); % initialize


for frequency = 1:num_freq
    for electrode_sub1 = 1:24
        for electrode_sub2 = 1:24
            [h,p,ci,stats] = ttest(power_calc_ES(:,frequency,electrode_sub1,electrode_sub2),power_calc_NS(:,frequency,electrode_sub1,electrode_sub2));
            pvalues_power_calc_ES_NS(frequency,electrode_sub1,electrode_sub2) = p;
            tvalues_power_calc_ES_NS(frequency,electrode_sub1,electrode_sub2) = stats.tstat;
        end
    end
end


%% PLOTS p-values

% angle
figure()

for frequency = 1:num_freq
subplot(5,8,frequency)
imagesc(squeeze(pvalues_angle_diff_ES_NS(frequency,:,:)));
colorbar;
caxis([0 .05]);
title(sprintf('Frequency %.2f Hz',round(frex(frequency),2)));
end

% power
figure()

for frequency = 1:num_freq
subplot(5,8,frequency)
imagesc(squeeze(pvalues_power_calc_ES_NS(frequency,:,:)));
colorbar;
caxis([0 .05]);
title(sprintf('Frequency %.2f Hz',round(frex(frequency),2)));
end

%% PLOTS t-values

% angle

max_t = max([max(max(max(tvalues_angle_diff_ES_NS)))]);
min_t = min([min(min(min(tvalues_angle_diff_ES_NS)))]);

figure()

for frequency = 1:num_freq
subplot(5,8,frequency)
imagesc(squeeze(tvalues_angle_diff_ES_NS(frequency,:,:)));
colorbar;
caxis([min_t max_t]);
title(sprintf('Frequency %.2f Hz',round(frex(frequency),2)));
end

% power

max_t = max([max(max(max(tvalues_power_calc_ES_NS)))]);
min_t = min([min(min(min(tvalues_power_calc_ES_NS)))]);

figure()

for frequency = 1:num_freq
subplot(5,8,frequency)
imagesc(squeeze(tvalues_power_calc_ES_NS(frequency,:,:)));
colorbar;
caxis([min_t max_t]);
title(sprintf('Frequency %.2f Hz',round(frex(frequency),2)));
end

%% calculate % of p-values < .05

% angle
pvalues_angle_diff_ES_NS_ratio = (sum(pvalues_angle_diff_ES_NS < .05, 'all')/(num_freq*24*24)) * 100;
pvalues_angle_diff_ES_NS_ratio

% power
pvalues_power_calc_ES_NS_ratio = (sum(pvalues_power_calc_ES_NS < .05, 'all')/(num_freq*24*24)) * 100;
pvalues_power_calc_ES_NS_ratio
