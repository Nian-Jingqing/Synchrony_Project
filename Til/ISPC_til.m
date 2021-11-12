%% Skript gets the InterSitePhaseClustering Index (MikeXCohen)
% for each pair 
% for each condition 
% for each frequency 
% for each electrode pair


% set filepath for loading and saving
filepath_loading = '/Volumes/til_uni/Uni/MasterthesisData/TF';
filepath_saving = '/Volumes/til_uni/Uni/MasterthesisData/ISPC_single';


%% Setup
fprintf('Setup');
% Lists contain only speaker/listeners sorted by pair
[pairS,pairL] = help_getpairs;
clearvars -except pairS pairL filepath_loading filepath_saving

n_pairs = length(pairS);
n_frex = 44;
n_elex = 24;

conditions = {'RS1' 'NS' 'RS2' 'ES' 'RS3'};

% Initialize matrizes
ISPC_RS1 = zeros(n_pairs,n_frex,n_elex,n_elex);
ISPC_NS  = zeros(n_pairs,n_frex,n_elex,n_elex);
ISPC_RS2 = zeros(n_pairs,n_frex,n_elex,n_elex);
ISPC_ES  = zeros(n_pairs,n_frex,n_elex,n_elex);
ISPC_RS3 = zeros(n_pairs,n_frex,n_elex,n_elex);

fprintf(' - done\n');


%% navigate to folder

cd(filepath_loading);
addpath(genpath(filepath_loading))

%% Calculate ISPC

% Loopchain: pair - condition - frequencies - electrodes
for pair = 1:length(pairS)
    
    fprintf('Pair %d of %d:\n',pair,length(pairS));
    tic
    for cond = 1:length(conditions)
        fprintf('Condition %s',conditions{cond});
        % matrix to be filled
        ISPC = zeros(n_frex,n_elex,n_elex);
        
        % load current condition for each subject of current pair
        tf_S = load(sprintf('tf_subject%s_roleS_condition%s.mat',pairS{pair},conditions{cond}));
        tf_L = load(sprintf('tf_subject%s_roleL_condition%s.mat',pairL{pair},conditions{cond}));
        
        for freq = 1:n_frex
            
            % matrix to be filled
            ISPC_freq = zeros(n_elex,n_elex);
            
            
            for elecS = 1:n_elex
                for elecL = 1:n_elex    
                    
                    % get Data & extract phase_angles
                    phase_angle_S = squeeze(angle(tf_S.tf_elec(elecS,freq,:)));
                    phase_angle_L = squeeze(angle(tf_L.tf_elec(elecL,freq,:)));
                    
                    % Get Difference (order is irrelevant)
                    diffs = phase_angle_S - phase_angle_L;
                    % Eulerize angles
                    euler_diffs = exp(1i*diffs);
                    % mean vector
                    mean_diff = mean(euler_diffs);
                    % ISPC = length of vector (Synchronisation value)
                    ISPC_value = abs(mean_diff);
                    
                    
                    % store p-a-d
                    ISPC_freq(elecS,elecL) = ISPC_value;
                    
                end 
            end % electrode loops
            ISPC(freq,:,:) = ISPC_freq;
        end % frequency loop
        
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
    end % condition loop
    % check progress
    fprintf('Pair %d of %d done',pair,length(pairS));
    toc
end % pair loop


%% Save matrices

fprintf('Saving');

cd(filepath_saving);
addpath(genpath(filepath_saving))

% save all conditions
save('ISPC_RS1.mat', 'ISPC_RS1','-v7.3');
save('ISPC_NS.mat', 'ISPC_NS','-v7.3');
save('ISPC_RS2.mat', 'ISPC_RS2','-v7.3');
save('ISPC_ES.mat', 'ISPC_ES','-v7.3');
save('ISPC_RS3.mat', 'ISPC_RS3','-v7.3');

fprintf(' - done\n');



