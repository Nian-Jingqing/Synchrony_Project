%% Script plots power correlations for each subject/condition/frequency

%% Load Data
fprintf('Loading files');
% check system to get correct filepath
if strcmp(getenv('USER'),'til')
    filepath = '/Volumes/til_uni/Uni/MasterthesisData/pow_corr';
else
    filepath = '';
end
cd(filepath);
addpath(genpath(filepath))


% load data
data_rs1 = load('pow_cor_RS1.mat');
data_ns  = load('pow_cor_NS.mat');
data_rs2 = load('pow_cor_RS2.mat');
data_es  = load('pow_cor_ES.mat');
data_rs3 = load('pow_cor_RS3.mat');

% extract field - cell(37x44x24x24) = pairs x frequencies x electrodes
% rows are listener electrodes, columns speaker electrodes
% (power_corr_til.m)
data_rs1 = data_rs1.pow_cor_RS1;
data_ns  = data_ns.pow_cor_NS;
data_rs2 = data_rs2.pow_cor_RS2;
data_es = data_es.pow_cor_ES;
data_rs3 = data_rs3.pow_cor_RS3;

fprintf(' - done \n');
%% Test for one pair

% Input:
pair = 1;
condition = 'RS1';

switch condition
    case 'RS1'
        data = data_rs1;
    case 'NS'
        data = data_ns;
    case 'RS2'
        data = data_rs2;
    case 'ES'
        data = data_es;
    case 'RS3'
        data = data_rs3;
end

% extract r&p
% first entry is r, second p (power_corr_til.m)
r_values = cellfun(@(v)v(1),data);
p_values = cellfun(@(v)v(2),data);

% calculate colorbarlimits for this pair
colormin = min(squeeze(r_values(pair,:)));
colormax = max(squeeze(r_values(pair,:)));
clims = [colormin colormax];



figure();
sgtitle(sprintf('Power Correlation of Pair %i during condition %s',pair,condition));
for freq = 1:44
    matrix = squeeze(r_values(pair,freq,:,:));
    subplot(8,6,freq)
    imagesc(matrix,clims);
    title(sprintf('%iHz',freq));
    xlabel('Listener');
    ylabel(sprintf('Speaker'));

    colorbar;
end

%% imagesc testing:

A = zeros(3,5);

for i = 1:3
    for j = 1:5
        A(i,j) = rand;
    end
end
