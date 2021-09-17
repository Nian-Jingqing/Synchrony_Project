srate = 500;
% frequency parameters
min_freq =  2; % in Hz
max_freq = 45; % in HZ
num_freq = 44; % in count

frex = linspace(min_freq,max_freq,num_freq);

time = (0:2*srate)/srate;
time = time - mean(time); % note the alternative method for creating centered time vector


% FOR LOOP over each file

% it is possible that we have to concatenate epochs for this
% here is example how
%
% concanate data
%  eeg_sub1.data = reshape(eeg_sub1.data, 24, []);

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
save(sprintf('tf_pair%s_condition%s_subject%s_role%d.mat','tf_elec'))