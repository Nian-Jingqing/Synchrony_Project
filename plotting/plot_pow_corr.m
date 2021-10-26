%% Script plots power correlations for each subject/condition/frequency
% section 2 - plots all conditions for chosen pair
% section 3 - saves plot of all subjects in folder (line 56)



% chose if you want to loop over all subjects.
% else script will only plot all conditions for chosen subject
loop = false;


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
fprintf('extract p and r');

% extract p and r values
% first entry is r, second p (power_corr_til.m)
r_rs1 = cellfun(@(e)e(1),data_rs1);
p_rs1 = cellfun(@(e)e(2),data_rs1);

r_ns = cellfun(@(e)e(1),data_ns);
p_ns = cellfun(@(e)e(2),data_ns);

r_rs2 = cellfun(@(e)e(1),data_rs2);
p_rs2 = cellfun(@(e)e(2),data_rs2);

r_es = cellfun(@(e)e(1),data_es);
p_es = cellfun(@(e)e(2),data_es);

r_rs3 = cellfun(@(e)e(1),data_rs3);
p_rs3 = cellfun(@(e)e(2),data_rs3);


fprintf(' - done \n');

%% Plot for one pair (chose)

if(~loop)
    % Input: (pair 1-37)
    pair = 1;

    % Resting state 1
    condition = 'RS1';
    r_vals = r_rs1;
    clims = colorlimits(r_vals,pair);
    plot_r_vals(pair,condition,r_vals,clims)

    % Neutral sharing
    condition = 'NS';
    r_vals = r_ns;
    clims = colorlimits(r_vals,pair);
    plot_r_vals(pair,condition,r_vals,clims)

    % Resting state 2
    condition = 'RS2';
    r_vals = r_rs2;
    clims = colorlimits(r_vals,pair);
    plot_r_vals(pair,condition,r_vals,clims)

    % Emotional sharing
    condition = 'ES';
    r_vals = r_es;
    clims = colorlimits(r_vals,pair);
    plot_r_vals(pair,condition,r_vals,clims)

    % Resting state 3
    condition = 'RS3';
    r_vals = r_rs3;
    clims = colorlimits(r_vals,pair);
    plot_r_vals(pair,condition,r_vals,clims)
end


%% loop over all subjects - save in folder

if(loop)
    % loop over subjects
    for pair = 1:37
        tic
        fprintf('plotting pair %i of 37',pair)

        % Resting state 1
        condition = 'RS1';
        r_vals = r_rs1;
        clims = colorlimits(r_vals,pair);
        plot_r_vals(pair,condition,r_vals,clims);
        save_correlationfigure(pair,condition);
        close;


        % Neutral sharing
        condition = 'NS';
        r_vals = r_ns;
        clims = colorlimits(r_vals,pair);
        plot_r_vals(pair,condition,r_vals,clims)
        save_correlationfigure(pair,condition);
        close;


        % Resting state 2
        condition = 'RS2';
        r_vals = r_rs2;
        clims = colorlimits(r_vals,pair);
        plot_r_vals(pair,condition,r_vals,clims)
        save_correlationfigure(pair,condition);
        close;


        % Emotional sharing
        condition = 'ES';
        r_vals = r_es;
        clims = colorlimits(r_vals,pair);
        plot_r_vals(pair,condition,r_vals,clims)
        save_correlationfigure(pair,condition);
        close;


        % Resting state 3
        condition = 'RS3';
        r_vals = r_rs3;
        clims = colorlimits(r_vals,pair);
        plot_r_vals(pair,condition,r_vals,clims)
        save_correlationfigure(pair,condition);
        close;


        fprintf(' - done \n'); toc
    end
end


%% print channames on x and y axes
printchannames



%% Helper functions

% plots r_values for each frequency as
% imagesc for electrode matrix
function plot_r_vals(pair,condition,r_vals,clims)
    figure();
    sgtitle(sprintf('Power Correlation of Pair %i during condition %s',pair,condition));
    for freq = 1:44
        matrix = squeeze(r_vals(pair,freq,:,:));
        subplot(8,6,freq)
        imagesc(matrix); 
        %imagesc(matrix,clims) 
        title(sprintf('%iHz',freq));
        xlabel('Listener');
        ylabel(sprintf('Speaker'));
        colorbar;
    end
end


function save_correlationfigure(pair,condition)
% chose folder location for saving
if strcmp(getenv('USER'),'til')
    supfolder = '/Volumes/til_uni/Uni/Plots/power_correlation';  
    filepath = sprintf('%s/pair_%i',supfolder,pair);
    if ~exist(filepath, 'dir')
        mkdir(filepath);
    end
else
    supfolder = '';  
    filepath = sprintf('%s/pair_%i',supfolder,pair);
    if ~exist(filepath, 'dir')
        mkdir(filepath);
    end
end
addpath(genpath(supfolder))
% navigate to folder
cd(filepath);

% save current figure as .fig
filename = sprintf('pow_corr_pair%i_cond%s',pair,condition);
savefig(filename)

% can be loaded with loadfig(filename)

end


% calculate colorbarlimits for given pair and r_values (condition)
function clims =  colorlimits(r_vals, pair)

    colormin = min(squeeze(r_vals(pair,:)));
    colormax = max(squeeze(r_vals(pair,:)));
    % returns
    clims = [colormin colormax];

end


% print channel names
function printchannames
    % get channames
    load('chanlocs.mat');
    chanlocs = {chanlocs.labels};

    for idx = 1:length(chanlocs)
        fprintf('%s\n',chanlocs{idx});
    end
    fprintf('   ');
    for idx = 1:length(chanlocs)
        fprintf('%s ',chanlocs{idx});
    end
end
