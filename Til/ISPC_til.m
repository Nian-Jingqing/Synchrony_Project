%% Skript gets the InterSitePhaseClustering Index (MikeXCohen)
% for each pair 
% for each condition 
% for each frequency 
% for each electrode pair
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


%% Set Parameters
fprintf('Setup');

n_pairs = length(pairS);
n_frex = 44;
n_elex = 24;

conditions = {'RS1' 'NS' 'RS2' 'ES' 'RS3'};

%% Initialize matrizes

ISPC_RS1 = cell(n_pairs,n_frex,n_elex,n_elex);
ISPC_NS  = cell(n_pairs,n_frex,n_elex,n_elex);
ISPC_RS2 = cell(n_pairs,n_frex,n_elex,n_elex);
ISPC_ES  = cell(n_pairs,n_frex,n_elex,n_elex);
ISPC_RS3 = cell(n_pairs,n_frex,n_elex,n_elex);

fprintf(' - done\n');
%% Calculate ISPC

% check system to get correct filepath
if strcmp(getenv('USER'),'til')
    filepath = '/Volumes/til_uni/Uni/MasterthesisData/TF';
else
    filepath = '';
end

cd(filepath);
addpath(genpath(filepath))

% Loopchain: pair - condition - frex - electrodes
% for each pair
for pair = 1:length(pairS)
    % for each condition
    fprintf('Pair %d of %d:\n',pair,length(pairS));
    tic
    for cond = 1:length(conditions)
        fprintf('Condition %s',conditions{cond});
        % matrix to be filled
        ISPC = cell(n_frex,n_elex,n_elex);
        
        % load current condition for each subject of current pair
        tf_S = load(sprintf('tf_subject%s_roleS_condition%s.mat',pairS{pair},conditions{cond}));
        tf_L = load(sprintf('tf_subject%s_roleL_condition%s.mat',pairL{pair},conditions{cond}));
        
        % for each freq
        for freq = 1:n_frex
            
            % matrix to be filled
            ISPC_freq = cell(n_elex,n_elex);
            
            % for each elec Speaker
            for elecS = 1:n_elex
                % for eaach elec Listener
                for elecL = 1:n_elex    
                    
                    % get Data & extract phase_angles
                    phase_angle_S = angle(tf_S.tf_elec(elecS,freq,:));
                    phase_angle_L = angle(tf_L.tf_elec(elecL,freq,:));
                    
                    % Get Difference (order is irrelevant)
                    diffs = phase_angle_S - phase_angle_L;
                    % Eulerize angles
                    euler_diffs = exp(1i*diffs);
                    % mean vector
                    mean_diff = mean(euler_diffs);
                    % ISPC = length of vector (Synchronisation value)
                    ISPC_value = abs(mean_diff);
                    
                    
                    % store p-a-d in cell
                    ISPC_freq(elecS,elecL) = {ISPC_value};
                    
                end 
            end
            ISPC(freq,:,:) = ISPC_freq;
        end
        
        % fill preinitialized matrizes
        switch conditions{cond}
            case 'RS1'
                ISPC_RS1(pair,:,:,:) = ISPC;
            case 'NS'
                ISPC_NS(pair,:,:,:)  = ISPC;
            case 'RS2'
                ISPC_RS2(pair,:,:,:) = ISPC;
            case 'ES'
                ISPC_ES(pair,:,:,:)  = ISPC;
            case 'RS3'
                ISPC_RS3(pair,:,:,:) = ISPC;
        end
        fprintf(' - done\n');
    end
    % check progress
    fprintf('Pair %d of %d done',pair,length(pairS));
    toc
end


%% Save matrices

fprintf('Saving');

% check system to get correct filepath
if strcmp(getenv('USER'),'til')
    filepath = '/Volumes/til_uni/Uni/MasterthesisData/ISPC_single';
else
    filepath = '';
end

cd(filepath);
addpath(genpath(filepath))

% save all conditions
save('ISPC_RS1.mat', 'ISPC_RS1','-v7.3');
save('ISPC_NS.mat', 'ISPC_NS','-v7.3');
save('ISPC_RS2.mat', 'ISPC_RS2','-v7.3');
save('ISPC_ES.mat', 'ISPC_ES','-v7.3');
save('ISPC_RS3.mat', 'ISPC_RS3','-v7.3');

fprintf(' - done\n');

