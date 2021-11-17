%% Script plots power for each frequency of selected Subject/Condition/electrode

filepath_loading = '/Volumes/til_uni/Uni/MasterthesisData/TF';
%% Set up
fprintf('Setup');
% Parameters - chose
subj = '085';

condA = 'RS1';
condB = 'ES';

electrode = 'Fz';

% load chanloc, get index of electrode
load('chanlocs.mat');
chanlocs = {chanlocs.labels};
el_idx = find(strcmp(chanlocs,electrode));

% navigate to folder

cd(filepath_loading);
addpath(genpath(filepath_loading));

fprintf(' - done\n');
%% load Data
fprintf('Loading Data');
% get all filenames
list = dir;
files = {list.name};

% load correct files
tf_A = load(files{contains(files,subj) & contains(files,condA)});
tf_B = load(files{contains(files,subj) & contains(files,condB)});

% select electrode
dataA = squeeze(tf_A.tf_elec(el_idx,:,:));
dataB = squeeze(tf_B.tf_elec(el_idx,:,:));

% extract power
powerA = abs(dataA).^2;
powerB = abs(dataB).^2;

fprintf(' - done\n');
%% Plotting
fprintf('Plot each frequency');
% portray maximum 300seconds at sr=500Hz
xlimits = [0 150000];


% Plot for condition A
figure();
sgtitle(sprintf('Power at electrode %s - subject %s during condition %s',electrode,subj,condA));
% for each frequency
for freq = 1:size(dataA,1)
    A_freq = powerA(freq,:);
    
    ax(1)= subplot(size(dataA,1),1,freq);
    plot(A_freq);
    xticklabels('off');
    xlim(xlimits)
    if(freq == size(dataA,1)/2)
        ylabel('Power: \muV^2','fontweight','bold');
    end
end
xlabel('Time[s]','fontweight','bold');
xticklabels(xticks/500);


% Plot for condition B
figure();
sgtitle(sprintf('Power at electrode %s - subject %s during condition %s',electrode,subj,condB));
% for each frequency
for freq = 1:size(dataA,1)
    B_freq = powerB(freq,:);
    
    bx(1)= subplot(size(dataA,1),1,freq);
    plot(B_freq);
    xticklabels('off');
    xlim(xlimits)
    if(freq == size(dataA,1)/2)
        ylabel('Power: \muV^2','fontweight','bold');
    end
end
xlabel('Time[s]','fontweight','bold');
xticklabels(xticks/500);


fprintf(' - done\n');
%% Preparation for frequency bands
fprintf('Plot frequency bands');
% theta 4-7Hz
% alpha 8-12Hz
% beta1 18-22Hz
% beta2 16-30Hz

% frequencies (from tf_til.m)
min_freq =  2; % in Hz
max_freq = 45; % in HZ
num_freq = 44; % in count
frex = linspace(min_freq,max_freq,num_freq);

theta = frex(frex >=  4 & frex <=  7);
alpha = frex(frex >=  8 & frex <= 12);
beta1 = frex(frex >= 18 & frex <= 22);
beta2 = frex(frex >= 16 & frex <= 30);

% calculate mean power over frequencies included in bands for condition A
A_theta = mean(powerA(theta(1):theta(end),:),1);
A_alpha = mean(powerA(alpha(1):alpha(end),:),1);
A_beta1 = mean(powerA(beta1(1):beta1(end),:),1);
A_beta2 = mean(powerA(beta2(1):beta2(end),:),1);

% calculate mean power over frequencies included in bands for condition B
B_theta = mean(powerB(theta(1):theta(end),:),1);
B_alpha = mean(powerB(alpha(1):alpha(end),:),1);
B_beta1 = mean(powerB(beta1(1):beta1(end),:),1);
B_beta2 = mean(powerB(beta2(1):beta2(end),:),1);

% get global ylimits
ylimitsA = ceil(max(cat(2,A_theta,A_alpha,A_beta1,A_beta2)));
ylimitsB = ceil(max(cat(2,B_theta,B_alpha,B_beta1,B_beta2)));
ylimits = [0 max(ylimitsA,ylimitsB)];

%% Plot Condition A

figure()
sgtitle(sprintf('Power at electrode %s - subject %s during condition %s',electrode,subj,condA),'fontweight','bold');

% conditionA theta band
subplot(4,1,1);
plot(A_theta);
xticklabels('off');
xlim(xlimits)
ylim(ylimits)
xlabel('Time[s]');
ylabel('Power: \muV^2');
xticklabels(xticks/500);
title(sprintf('Theta Band (%iHz - %iHz)',theta(1),theta(end)));


% conditionA - alpha band
subplot(4,1,2);
plot(A_alpha);
xticklabels('off');
xlim(xlimits)
ylim(ylimits)
xlabel('Time[s]');
ylabel('Power: \muV^2');
xticklabels(xticks/500);
title(sprintf('Alpha Band (%iHz - %iHz)',alpha(1),alpha(end)));


% conditionA - beta1 band
subplot(4,1,3);
plot(A_beta1);
xticklabels('off');
xlim(xlimits)
ylim(ylimits)
xlabel('Time[s]');
ylabel('Power: \muV^2');
xticklabels(xticks/500);
title(sprintf('Beta Band (%iHz - %iHz)',beta1(1),beta1(end)));


% conditionA - beta2 band
subplot(4,1,4 );
plot(A_beta2);
xticklabels('off');
xlim(xlimits)
ylim(ylimits)
xlabel('Time[s]');
ylabel('Power: \muV^2');
xticklabels(xticks/500);
title(sprintf('Beta Band (%iHz - %iHz)',beta2(1),beta2(end)));

%% Plot Condition B

figure()
sgtitle(sprintf('Power at electrode %s - subject %s during condition %s',electrode,subj,condB),'fontweight','bold');

% conditionA theta band
subplot(4,1,1);
plot(B_theta);
xticklabels('off');
xlim(xlimits)
ylim(ylimits)
xlabel('Time[s]');
ylabel('Power: \muV^2');
xticklabels(xticks/500);
title(sprintf('Theta Band (%iHz - %iHz)',theta(1),theta(end)));


% conditionA - alpha band
subplot(4,1,2);
plot(B_alpha);
xticklabels('off');
xlim(xlimits)
ylim(ylimits)
xlabel('Time[s]');
ylabel('Power: \muV^2');
xticklabels(xticks/500);
title(sprintf('Alpha Band (%iHz - %iHz)',alpha(1),alpha(end)));


% conditionA - beta1 band
subplot(4,1,3);
plot(B_beta1);
xticklabels('off');
xlim(xlimits)
ylim(ylimits)
xlabel('Time[s]');
ylabel('Power: \muV^2');
xticklabels(xticks/500);
title(sprintf('Beta Band (%iHz - %iHz)',beta1(1),beta1(end)));


% conditionA - beta2 band
subplot(4,1,4 );
plot(B_beta2);
xticklabels('off');
xlim(xlimits)
ylim(ylimits)
xlabel('Time[s]');
ylabel('Power: \muV^2');
xticklabels(xticks/500);
title(sprintf('Beta Band (%iHz - %iHz)',beta2(1),beta2(end)));

fprintf(' - done\n');
