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

correlations_RS1 = zeros(23, 43,24,24);
correlations_RS2 = zeros(23, 43,24,24);
correlations_RS3 = zeros(23, 43,24,24);
pvalues_RS1 = zeros(23, 43,24,24);
pvalues_RS2 = zeros(23, 43,24,24);
pvalues_RS3 = zeros(23, 43,24,24);

conditions = zeros(23,1);

% for loop
%for pair = 1:23
    
pair = 1;

    eeg_sub_1_RS1 = pop_loadset('filename',sprintf('hyper_cleaned_SNS_%s%s_%s%s_%s_RS1_sub_1.set',cell2mat(pairs_A(pair)),list_of_files(pair).name(22), cell2mat(pairs_B(pair)),list_of_files(pair).name(27),list_of_files(pair).name(29)), 'check', 'off', 'loadmode', 'info');
    eeg_sub_2_RS1 = pop_loadset('filename',sprintf('hyper_cleaned_SNS_%s%s_%s%s_%s_RS1_sub_2.set',cell2mat(pairs_A(pair)),list_of_files(pair).name(22), cell2mat(pairs_B(pair)),list_of_files(pair).name(27),list_of_files(pair).name(29)), 'check', 'off', 'loadmode', 'info');
    
    eeg_sub_1_RS2 = pop_loadset('filename',sprintf('hyper_cleaned_SNS_%s%s_%s%s_%s_RS2_sub_1.set',cell2mat(pairs_A(pair)),list_of_files(pair).name(22), cell2mat(pairs_B(pair)),list_of_files(pair).name(27),list_of_files(pair).name(29)), 'check', 'off', 'loadmode', 'info');
    eeg_sub_2_RS2 = pop_loadset('filename',sprintf('hyper_cleaned_SNS_%s%s_%s%s_%s_RS2_sub_2.set',cell2mat(pairs_A(pair)),list_of_files(pair).name(22), cell2mat(pairs_B(pair)),list_of_files(pair).name(27),list_of_files(pair).name(29)), 'check', 'off', 'loadmode', 'info');
    
    eeg_sub_1_RS3 = pop_loadset('filename',sprintf('hyper_cleaned_SNS_%s%s_%s%s_%s_RS3_sub_1.set',cell2mat(pairs_A(pair)),list_of_files(pair).name(22), cell2mat(pairs_B(pair)),list_of_files(pair).name(27),list_of_files(pair).name(29)), 'check', 'off', 'loadmode', 'info');
    eeg_sub_2_RS3 = pop_loadset('filename',sprintf('hyper_cleaned_SNS_%s%s_%s%s_%s_RS3_sub_2.set',cell2mat(pairs_A(pair)),list_of_files(pair).name(22), cell2mat(pairs_B(pair)),list_of_files(pair).name(27),list_of_files(pair).name(29)), 'check', 'off', 'loadmode', 'info');
    
    
    
    
    
    if list_of_files(pair).name(29) == 'E'
        conditions(pair) = 'E';
    elseif list_of_files(pair).name(29) == 'N'
        conditions(pair) = 'N';
    end
    
    srate = 500;
    % frequency parameters
    min_freq =  2; % in Hz
    max_freq = 45; % in HZ
    num_freq = 43; % in count
    
    frex = linspace(min_freq,max_freq,num_freq);
    
    time = (0:2*srate)/srate;
    time = time - mean(time); % note the alternative method for creating centered time vector
    
    
    for condition = 1:3
        
        tf_elec_sub1 = [];
        tf_elec_sub2 = [];
        
        for subject = 1:2
            if (subject == 1 & condition == 1)
                data = eeg_sub_1_RS1.data(:,:);
            elseif (subject == 1 & condition == 2)
                data = eeg_sub_1_RS2.data(:,:);
            elseif (subject == 1 & condition == 3)
                data = eeg_sub_1_RS3.data(:,:);
            elseif (subject == 2 & condition == 1)
                data = eeg_sub_2_RS1.data(:,:);
            elseif (subject == 2 & condition == 2)
                data = eeg_sub_2_RS2.data(:,:);
            elseif (subject == 2 & condition == 3)
                data = eeg_sub_2_RS3.data(:,:);
            end
            timevec = linspace(0,300, size(data,2));
            tf_elec = zeros(24,num_freq,length(timevec));
            
            for electrode = 1:24
                data_e = data(electrode,:);
                
                % reshape the data to be 1D
                dataR = reshape(data_e,1,[]);
                
                % Step 1: N's of convolution
                ndata = length(dataR); % note the different variable name!
                nkern = length(time);
                nConv = ndata + nkern - 2;
                halfK = floor(nkern/2);
                
                % Step 2: FFTs
                dataX = fft( dataR,nConv );
                
                % initialize TF matrix
                tf = zeros(num_freq,length(timevec));
                
                for fi=1:num_freq
                    
                    % create wavelet
                    cmw  = exp(1i*2*pi*frex(fi)*time) .* ...
                        exp( -4*log(2)*time.^2 / .3^2 );
                    
                    cmwX = fft(cmw,nConv);
                    cmwX = cmwX./max(cmwX);
                    % the rest of convolution
                    as = ifft( dataX.*cmwX );
                    as = as(halfK+1:end-halfK+1);
                    as = reshape(as,size(data_e));
                    % average over trials and put in matrix
                    tf(fi,:) = as;
                end
                
                tf_elec(electrode,:,:) = tf;
                if subject == 1
                    tf_elec_sub1 = tf_elec;
                elseif subject == 2
                    tf_elec_sub2 = tf_elec;
                end
            end
        end
        
        correlations = zeros(43,24,24);
        pvalues = zeros(43,24,24);
        
        for frequencies = 1:43
            freq_c = zeros(24,24);
            freq_p = zeros(24,24);
            for electrodes_sub1 = 1:24
                data1 = squeeze(angle(tf_elec_sub1(electrodes_sub1,frequencies,:)));
                for electrodes_sub2 = 1:24
                    data2 = squeeze(angle(tf_elec_sub2(electrodes_sub2,frequencies,:)));
                    [c p] = circ_corrcc(data1,data2);
                    freq_c(electrodes_sub1,electrodes_sub2) = c;
                    freq_p(electrodes_sub1,electrodes_sub2) = p;
                end
            end
            correlations(frequencies,:,:) = freq_c;
            pvalues(frequencies,:,:) = freq_p;
        end
        
        if condition == 1
            correlations_RS1(pair,:,:,:) = correlations;
            pvalues_RS1(pair,:,:,:) = pvalues;
        elseif condition == 2
            correlations_RS2(pair,:,:,:) = correlations;
            pvalues_RS2(pair,:,:,:) = pvalues;
        elseif condition == 3
            correlations_RS3(pair,:,:,:) = correlations;
            pvalues_RS3(pair,:,:,:) = pvalues;
        end
    end
%end