%% Script plots ISPC values for each subject/condition/frequency
% section 2 - plots all conditions for chosen pair
% section 3 - saves plot of all subjects in folder (line 56)
% section 4 - plots all conditions averaged over pairs



% chose which parts to execute
plot_all_pairs = false;
plot_selected_pair = false;
plot_average_pairs = true;



%% Load Data
fprintf('Loading files');
% check system to get correct filepath
if strcmp(getenv('USER'),'til')
    filepath = '/Volumes/til_uni/Uni/MasterthesisData/ISPC_single';
else
    filepath = '';
end
cd(filepath);
addpath(genpath(filepath))


% load data 
ispc_rs1 = load('ISPC_RS1.mat');
ispc_ns  = load('ISPC_NS.mat');
ispc_rs2 = load('ISPC_RS2.mat');
ispc_es  = load('ISPC_ES.mat');
ispc_rs3 = load('ISPC_RS3.mat');

% extract data from field - double(37x44x24x24) 
% = pairs x frequencies x electrodes
ispc_rs1 = ispc_rs1.ISPC_RS1;
ispc_ns = ispc_ns.ISPC_NS;
ispc_rs2 = ispc_rs2.ISPC_RS2;
ispc_es = ispc_es.ISPC_ES;
ispc_rs3 = ispc_rs3.ISPC_RS3;


fprintf(' - done \n');

%% Plot for one pair (chose)

if(plot_selected_pair)
    % Input: (pair 1-37)
    pair = 1;

    % Resting state 1
    condition = 'RS1';
    data = ispc_rs1;
    clims = colorlimits(data,pair);
    plot_ispcs(pair,condition,data,clims)

    % Neutral sharing
    condition = 'NS';
    data = ispc_ns;
    clims = colorlimits(data,pair);
    plot_ispcs(pair,condition,data,clims)

    % Resting state 2
    condition = 'RS2';
    data = ispc_rs2;
    clims = colorlimits(data,pair);
    plot_ispcs(pair,condition,data,clims)

    % Emotional sharing
    condition = 'ES';
    data = ispc_es;
    clims = colorlimits(data,pair);
    plot_ispcs(pair,condition,data,clims)

    % Resting state 3
    condition = 'RS3';
    data = ispc_rs3;
    clims = colorlimits(data,pair);
    plot_ispcs(pair,condition,data,clims)
end


%% loop over all subjects - save in folder

if(plot_all_pairs)
    % loop over subjects
    for pair = 1:37
        tic
        fprintf('plotting pair %i of 37',pair)

        % Resting state 1
        condition = 'RS1';
        data = ispc_rs1;
        clims = colorlimits(data,pair);
        plot_ispcs(pair,condition,data,clims);
        save_correlationfigure(pair,condition);
        close;


        % Neutral sharing
        condition = 'NS';
        data = ispc_ns;
        clims = colorlimits(data,pair);
        plot_ispcs(pair,condition,data,clims)
        save_correlationfigure(pair,condition);
        close;


        % Resting state 2
        condition = 'RS2';
        data = ispc_rs2;
        clims = colorlimits(data,pair);
        plot_ispcs(pair,condition,data,clims)
        save_correlationfigure(pair,condition);
        close;


        % Emotional sharing
        condition = 'ES';
        data = ispc_es;
        clims = colorlimits(data,pair);
        plot_ispcs(pair,condition,data,clims)
        save_correlationfigure(pair,condition);
        close;


        % Resting state 3
        condition = 'RS3';
        data = ispc_rs3;
        clims = colorlimits(data,pair);
        plot_ispcs(pair,condition,data,clims)
        save_correlationfigure(pair,condition);
        close;


        fprintf(' - done \n'); toc
    end
end
%% average ISPC over pairs:
if(plot_average_pairs)
    
    % RS1
    condition = 'RS1';
    % avg over pairs
    data = squeeze(mean(ispc_rs1,1));
    
    figure();
    sgtitle(sprintf('Average ISPC (37 pairs) during condition %s',condition));
    for freq = 1:44
        matrix = squeeze(data(freq,:,:));
        subplot(8,6,freq)
        imagesc(matrix); 
        title(sprintf('%iHz',freq));
        xlabel('Listener');
        ylabel(sprintf('Speaker'));
        colorbar;
    end
    
    % NS
    condition = 'NS';
    % avg over pairs
    data = squeeze(mean(ispc_ns,1));
    
    figure();
    sgtitle(sprintf('Average ISPC (37 pairs) during condition %s',condition));
    for freq = 1:44
        matrix = squeeze(data(freq,:,:));
        subplot(8,6,freq)
        imagesc(matrix); 
        title(sprintf('%iHz',freq));
        xlabel('Listener');
        ylabel(sprintf('Speaker'));
        colorbar;
    end
    
    % RS2
    condition = 'RS2';
    % avg over pairs
    data = squeeze(mean(ispc_rs2,1));
    
    figure();
    sgtitle(sprintf('Average ISPC (37 pairs) during condition %s',condition));
    for freq = 1:44
        matrix = squeeze(data(freq,:,:));
        subplot(8,6,freq)
        imagesc(matrix); 
        title(sprintf('%iHz',freq));
        xlabel('Listener');
        ylabel(sprintf('Speaker'));
        colorbar;
    end
    
    % ES
    condition = 'ES';
    % avg over pairs
    data = squeeze(mean(ispc_es,1));
    
    figure();
    sgtitle(sprintf('Average ISPC (37 pairs) during condition %s',condition));
    for freq = 1:44
        matrix = squeeze(data(freq,:,:));
        subplot(8,6,freq)
        imagesc(matrix); 
        title(sprintf('%iHz',freq));
        xlabel('Listener');
        ylabel(sprintf('Speaker'));
        colorbar;
    end
    
    % RS3
    condition = 'RS3';
    % avg over pairs
    data = squeeze(mean(ispc_rs3,1));
    
    figure();
    sgtitle(sprintf('Average ISPC (37 pairs) during condition %s',condition));
    for freq = 1:44
        matrix = squeeze(data(freq,:,:));
        subplot(8,6,freq)
        imagesc(matrix); 
        title(sprintf('%iHz',freq));
        xlabel('Listener');
        ylabel(sprintf('Speaker'));
        colorbar;
    end
end

%% print channames on x and y axes
printchannames



%% Helper functions

% plots ispc values for each frequency as
% imagesc for electrode matrix
function plot_ispcs(pair,condition,ispc,clims)
    figure();
    sgtitle(sprintf('Inter Site Phase Clustering of pair %i during condition %s',pair,condition));
    for freq = 1:44
        matrix = squeeze(ispc(pair,freq,:,:));
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
    supfolder = '/Volumes/til_uni/Uni/Plots/ISPC';  
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
filename = sprintf('ISPC_pair%i_cond%s',pair,condition);
savefig(filename)

% can be loaded with loadfig(filename)

end


% calculate colorbarlimits for given pair and r_values (condition)
function clims =  colorlimits(data, pair)

    colormin = min(squeeze(data(pair,:)));
    colormax = max(squeeze(data(pair,:)));
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
