%% Load data
cd D:\Dropbox\Synchrony_Adam
addpath(genpath('D:\Dropbox\Synchrony_Adam'))
eeglabpath = fileparts(which('eeglab.m'));
% load eeglab
eeglab;


cd D:\Dropbox\Synchrony_Adam\EEG_Data\preprocessed_ready\hyper_cleaned
list_of_files = dir('**/*ES_sub_1.set');

pairs_A = {'057' '059' '063' '065' '069' '074' '075' '079' '081' '085'};
pairs_B = {'058' '060' '064' '066' '070' '074' '076' '080' '082' '086'};

cd D:\Dropbox\Synchrony_Adam\EEG_Data\TF_extracted



% for loop
for pair = 1:10
    
    
    eeg_sub_1_RS1 = pop_loadset('filename',sprintf('hyper_cleaned_SNS_%s%s_%s%s_%s_RS1_sub_1.set',cell2mat(pairs_A(pair)),list_of_files(pair).name(22), cell2mat(pairs_B(pair)),list_of_files(pair).name(27),list_of_files(pair).name(29)), 'check', 'off', 'loadmode', 'info');
    eeg_sub_2_RS1 = pop_loadset('filename',sprintf('hyper_cleaned_SNS_%s%s_%s%s_%s_RS1_sub_2.set',cell2mat(pairs_A(pair)),list_of_files(pair).name(22), cell2mat(pairs_B(pair)),list_of_files(pair).name(27),list_of_files(pair).name(29)), 'check', 'off', 'loadmode', 'info');
    
    eeg_sub_1_RS2 = pop_loadset('filename',sprintf('hyper_cleaned_SNS_%s%s_%s%s_%s_RS2_sub_1.set',cell2mat(pairs_A(pair)),list_of_files(pair).name(22), cell2mat(pairs_B(pair)),list_of_files(pair).name(27),list_of_files(pair).name(29)), 'check', 'off', 'loadmode', 'info');
    eeg_sub_2_RS2 = pop_loadset('filename',sprintf('hyper_cleaned_SNS_%s%s_%s%s_%s_RS2_sub_2.set',cell2mat(pairs_A(pair)),list_of_files(pair).name(22), cell2mat(pairs_B(pair)),list_of_files(pair).name(27),list_of_files(pair).name(29)), 'check', 'off', 'loadmode', 'info');
    
    eeg_sub_1_RS3 = pop_loadset('filename',sprintf('hyper_cleaned_SNS_%s%s_%s%s_%s_RS3_sub_1.set',cell2mat(pairs_A(pair)),list_of_files(pair).name(22), cell2mat(pairs_B(pair)),list_of_files(pair).name(27),list_of_files(pair).name(29)), 'check', 'off', 'loadmode', 'info');
    eeg_sub_2_RS3 = pop_loadset('filename',sprintf('hyper_cleaned_SNS_%s%s_%s%s_%s_RS3_sub_2.set',cell2mat(pairs_A(pair)),list_of_files(pair).name(22), cell2mat(pairs_B(pair)),list_of_files(pair).name(27),list_of_files(pair).name(29)), 'check', 'off', 'loadmode', 'info');

    
    srate = 500;
    % frequency parameters
    min_freq =  2; % in Hz
    max_freq = 45; % in HZ
    num_freq = 44; % in count
    
    frex = linspace(min_freq,max_freq,num_freq);
    
    time = (0:2*srate)/srate;
    time = time - mean(time); % note the alternative method for creating centered time vector
    
    
    for condition = 1:3        
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
            
            tf_elec = zeros(24, num_freq, length(timevec));
            
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
            end
            save(sprintf('tf_pair%s_condition%s_subject%s.mat','tf_elec'))
        end
    end
end
