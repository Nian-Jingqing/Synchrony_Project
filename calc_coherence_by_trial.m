% Load data
cd D:\Dropbox\Synchrony_Adam
addpath(genpath('D:\Dropbox\Synchrony_Adam'))

coh_RS1 = zeros(23, 44, 24, 24);
coh_RS2 = zeros(23, 44, 24, 24);
coh_RS3 = zeros(23, 44, 24, 24);


num_freq = 44;
trial_size = 500;

for pair = 1:23
    for condition = 1:3
        load(sprintf('tf_pair%d_condition%d_subject1.mat',pair,condition));
        tf_elec_sub1 = tf_elec;
        load(sprintf('tf_pair%d_condition%d_subject2.mat',pair,condition));
        tf_elec_sub2 = tf_elec;
        
        n = size(tf_elec_sub1,3);
        trials = n/500;
        
        data1 = reshape(tf_elec_sub1, [24, 44, 500, trials]);
        data2 = reshape(tf_elec_sub2, [24, 44, 500, trials]);
        
        data1 = permute(data1, [4 3 1 2]);
        data2 = permute(data2, [4 3 1 2]);
        
        x1all=data1;
        x2all=data2;
        
        % power
        px1all=abs(x1all);
        px2all=abs(x2all);
        
        Ntrials = trials;
        
        %normalize fourier coeffs with power
        normx1all=x1all./px1all;
        normx2all=x2all./px2all;
        
        allpowzNMx1=px1all./repmat(nanstd(px1all,0,1),[Ntrials,1,1]);
        allpowzNMx2=px2all./repmat(nanstd(px2all,0,1),[Ntrials,1,1]);
        
        zx1all=allpowzNMx1.*normx1all;
        zx2all=allpowzNMx2.*normx2all;
        
        tmpCrSxy=zx1all.*conj(zx2all);
        tmpCrSxx=zx1all.*conj(zx1all);
        tmpCrSyy=zx2all.*conj(zx2all);
        
        
        Cxy=squeeze(nanmean(tmpCrSxy,1));
        Cxx=squeeze(nanmean(tmpCrSxx,1));
        Cyy=squeeze(nanmean(tmpCrSyy,1));
        
        Coherency = zeros(24,24,44);
        
        for freq = 1:size(Cxx,3)
            for iChan = 1:size(Cxx,2) %for each chan
                for jChan = 1:size(Cxx,2)
                    Coherency(iChan,jChan,freq)=mean(squeeze(Cxy(:,iChan,freq)./sqrt(Cxx(:,iChan,freq).*Cxy(:,jChan,freq)))); % i added mean here
                    %Coherency=squeeze(Cxy./sqrt(Cxx.*Cyy));
                end
            end
        end
        %------------------------------------------------------------------------
        % Coherence
        coh=abs(Coherency).^2;
        coh = permute(coh, [3 1 2]);
        
        if condition == 1
            coh_RS1(pair,:,:,:) = coh;
        elseif condition == 2
            coh_RS2(pair,:,:,:) = coh;
        elseif condition == 3
            coh_RS3(pair,:,:,:) = coh;
        end
    end
end

cd D:\Dropbox\Synchrony_Adam\EEG_Data\coh

save('coh_RS1.mat', 'coh_RS1')
save('coh_RS2.mat', 'coh_RS2')
save('coh_RS3.mat', 'coh_RS3')