%% Helperscript to choose path for saving/loading

if strcmp(getenv('USER'),'til')
    cd /Users/til/Uni/Master/_Ma.Thesis
    filepath = '/Users/til/Uni/Master/_Ma.Thesis/analysis_data';
    if ~exist(filepath, 'dir')
        mkdir(filepath);
    end
    
else % Arturs path
    cd D:\Dropbox\Projects\Emotional_Sharing_EEG
    filepath = 'D:\Dropbox\Projects\Emotional_Sharing_EEG\EEG_Data\TF';
    if ~exist(filepath, 'dir')
        mkdir(filepath);
    end
    
end

