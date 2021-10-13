%% Set Parameters
n_pairs = 39;
n_frex = 44;
n_elex = 24;

conditions = ['RS1' 'NS' 'RS2' 'ES' 'RS3'];
%% Initialize matrizes

pow_cor_RS1 = zeros(n_pairs,n_frex,n_elex,n_elex);
pow_cor_NS  = zeros(n_pairs,n_frex,n_elex,n_elex);
pow_cor_RS2 = zeros(n_pairs,n_frex,n_elex,n_elex);
pow_cor_ES  = zeros(n_pairs,n_frex,n_elex,n_elex);
pow_cor_RS3 = zeros(n_pairs,n_frex,n_elex,n_elex);

%% Load Data
help_chose_analysisfolder % get filepath

cd(filepath); %%TODO 


% separate subjects into speaker and listener lists
help_datacollector;

pairS = {};
pairL = {};

for idx = 1:length(list_of_files)
    % split filenames
    sub_a =  list_of_files(idx).name(19:21);
    role_a = list_of_files(idx).name(22);
    sub_b =  list_of_files(idx).name(24:26);
    role_b = list_of_files(idx).name(27);
    
    
    switch role_a
        % if 1st subj is Speaker, assign to pairS...
        % and 2nd subject to pairL
        % keep members of lists unique
        case 'S'
            if(~ismember(sub_a,pairS))
                pairS = [pairS;sub_a];
                pairL = [pairL;sub_b];
            end
        % if 1st subj is Speaker, assign to pairL...
        % and 2nd subject to pairS
        % keep members of lists unique
        case 'L'
            if(~ismember(sub_a,pairL))
                pairL = [pairL;sub_a];
                pairS = [pairS;sub_b];
            end
    end
end

% check for pair consistency
if(length(pairS) ~= length(pairL))
    error('Not equal amounts of speakers and listeners');
end

%% for each pair
for pair = 1:length(pairS)
    % for each condition
    for cond = 1:length(conditions)
        
        pow_cor = zeros(n_freq,n_elex,n_elex);
        
        tf_S = load(sprintf('tf_subject%s_roleS_conditinon%s.mat',pairS{pair},conditions(cond)));
        tf_L = load(sprintf('tf_subject%s_roleL_conditinon%s.mat',pairL{pair},conditions(cond)));
        
        % for each freq
        for freq = 1:n_frex
            pow_cor_freq = zeros(n_elex,n_elex);
            % for each elec Speaker
            for elecS = 1:n_elex
                % for eaach elec Listener
                for elecL = 1:n_elex    
                    
                    % get Data & extract power
                    pow_S = abs(tf_S(elecS,freq,:)).^2;
                    pow_L = abs(tf_L(elecL,freq,:)).^2;
                    
                    % DO CORRELATION
                    pow_cor_freq(elecS,elecL) = mean(corrcoef(pow_S,pow_L));
                end 
            end
            pow_cor(freq,:,:) = pow_cor_freq;
        end
        
        % fill preinitialized matrizes
        switch condition(cond)
            case 'RS1'
                pow_cor_RS1(pair,:,:,:) = pow_cor;
            case 'NS'
                pow_cor_NS(pair,:,:,:)  = pow_cor;
            case 'RS2'
                pow_cor_RS2(pair,:,:,:) = pow_cor;
            case 'ES'
                pow_cor_ES(pair,:,:,:)  = pow_cor;
            case 'RS3'
                pow_cor_RS3(pair,:,:,:) = pow_cor;
        end
    end
end


%% Save matrices
% navigate to folder

save('pow_cor_RS1.mat', 'pow_cor_trial_RS1','-v7.3');
save('pow_cor_NS.mat', 'pow_cor_trial_NS','-v7.3');
save('pow_cor_RS2.mat', 'pow_cor_trial_RS2','-v7.3');
save('pow_cor_ES.mat', 'pow_cor_trial_ES','-v7.3');
save('pow_cor_RS3.mat', 'pow_cor_trial_RS3','-v7.3');


