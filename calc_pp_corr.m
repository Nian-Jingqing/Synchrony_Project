% Load data
cd D:\Dropbox\Synchrony_Adam
addpath(genpath('D:\Dropbox\Synchrony_Adam'))

pp_corr_RS1 = zeros(23, 44, 24, 24);
pp_corr_RS2 = zeros(23, 44, 24, 24);
pp_corr_RS3 = zeros(23, 44, 24, 24);


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
        
        x1orthx2=abs(imag(x1all.*conj(x2all)./abs(x2all)));
        x2orthx1=abs(imag(x2all.*conj(x1all)./abs(x1all)));
        
        Zx1orthx2=(x1orthx2-repmat(nanmean(x1orthx2,1),[Ntrials,1,1]))./repmat(nanstd(x1orthx2,0,1),[Ntrials,1,1]);
        Zx2orthx1=(x2orthx1-repmat(nanmean(x2orthx1,1),[Ntrials,1,1]))./repmat(nanstd(x2orthx1,0,1),[Ntrials,1,1]);
    
        allpowzx1=(px1all-repmat(nanmean(px1all,1),[Ntrials,1,1]))./repmat(nanstd(px1all,0,1),[Ntrials,1,1]);
        allpowzx2=(px2all-repmat(nanmean(px2all,1),[Ntrials,1,1]))./repmat(nanstd(px2all,0,1),[Ntrials,1,1]);
    
        tmpcorlorth2 = zeros(24,24,44);
        tmpcor2orth1 = zeros(24,24,44);
        
        for freq = 1:size(allpowzx1,4)
            for iChan = 1:size(allpowzx1,3) %for each chan
                for jChan = 1:size(allpowzx1,3)
                    tmpcorlorth2(iChan,jChan,freq)= squeeze(mean(nansum(Zx1orthx2(:,:,iChan,freq).*allpowzx2(:,:,jChan,freq),1)./(Ntrials-1))); % i added mean here
                    tmpcor2orth1(iChan,jChan,freq)= squeeze(mean(nansum(Zx2orthx1(:,:,iChan,freq).*allpowzx1(:,:,jChan,freq),1)./(Ntrials-1)));
                end
            end
        end
                 
        projpowercor =( tmpcorlorth2 + tmpcor2orth1 )./2;
        projpowercor = permute(projpowercor, [3 1 2]);
        
        if condition == 1
            pp_corr_RS1(pair,:,:,:) = projpowercor;
        elseif condition == 2
            pp_corr_RS2(pair,:,:,:) = projpowercor;
        elseif condition == 3
            pp_corr_RS3(pair,:,:,:) = projpowercor;
        end
    end
end

cd D:\Dropbox\Synchrony_Adam\EEG_Data\pp_corr

save('pp_corr_RS1.mat', 'pp_corr_RS1')
save('pp_corr_RS2.mat', 'pp_corr_RS2')
save('pp_corr_RS3.mat', 'pp_corr_RS3')