%% Script plots power correlations for each subject/condition/frequency
% section 2 - plots all conditions for chosen pair
% section 3 - saves plot of all subjects in folder (line 56)
% section 4 - plots all conditions averaged over pairs


% chose which parts to execute
plot_all_pairs = false;
plot_selected_pair = false;
plot_average_pairs = true;
statistics = true;



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

if(plot_selected_pair)
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

if(plot_all_pairs)
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
%% average power correlation over pairs:
if(plot_average_pairs)
    
    % RS1
    condition = 'RS1';
    % avg over pairs
    r_vals = squeeze(mean(r_rs1,1));
    
    figure();
    sgtitle(sprintf('Average Power Correlation (37 pairs) during condition %s',condition));
    for freq = 1:44
        matrix = squeeze(r_vals(freq,:,:));
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
    r_vals = squeeze(mean(r_ns,1));
    
    figure();
    sgtitle(sprintf('Average Power Correlation (37 pairs) during condition %s',condition));
    for freq = 1:44
        matrix = squeeze(r_vals(freq,:,:));
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
    r_vals = squeeze(mean(r_rs2,1));
    
    figure();
    sgtitle(sprintf('Average Power Correlation (37 pairs) during condition %s',condition));
    for freq = 1:44
        matrix = squeeze(r_vals(freq,:,:));
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
    r_vals = squeeze(mean(r_es,1));
    
    figure();
    sgtitle(sprintf('Average Power Correlation (37 pairs) during condition %s',condition));
    for freq = 1:44
        matrix = squeeze(r_vals(freq,:,:));
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
    r_vals = squeeze(mean(r_rs3,1));
    
    figure();
    sgtitle(sprintf('Average Power Correlation (37 pairs) during condition %s',condition));
    for freq = 1:44
        matrix = squeeze(r_vals(freq,:,:));
        subplot(8,6,freq)
        imagesc(matrix); 
        title(sprintf('%iHz',freq));
        xlabel('Listener');
        ylabel(sprintf('Speaker'));
        colorbar;
    end
end
%% Statistics:
if(statistics)
    % # of p-vals < 0.05
    threshold = 0.05;
    number_of_comparisons = 37*44*24*24;

    sum_of_rs1 = sum(p_rs1(:) < threshold);
    sum_of_ns  = sum(p_ns(:)  < threshold);
    sum_of_rs2 = sum(p_rs2(:) < threshold);
    sum_of_es  = sum(p_es(:)  < threshold);
    sum_of_rs3 = sum(p_rs3(:) < threshold);

    total_sum = sum_of_rs1 +...
                sum_of_ns + ...
                sum_of_rs2 +...
                sum_of_es + ...
                sum_of_rs3;

    ratio = total_sum/(number_of_comparisons*5);
    ratio = round(ratio,4)*100;

    fprintf(' RS1: %i of %i comparisons are significant\n ',sum_of_rs1,number_of_comparisons)
    fprintf(' NS: %i of %i comparisons are significant\n ',sum_of_ns,number_of_comparisons)
    fprintf('RS2: %i of %i comparisons are significant\n ',sum_of_rs2,number_of_comparisons)
    fprintf(' ES: %i of %i comparisons are significant\n ',sum_of_es,number_of_comparisons)
    fprintf('RS2: %i of %i comparisons are significant\n ',sum_of_rs3,number_of_comparisons)
    fprintf('In Total: %i of %i comparisons are significant (%.2f%%)\n ',total_sum,number_of_comparisons*5,ratio)
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
