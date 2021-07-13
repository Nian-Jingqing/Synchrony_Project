path_to_file = [list_of_files(1).folder '\' list_of_files(1).name];
path_new_folder = sprintf('D:\\Dropbox\\Synchrony_Adam\\EEG_Data\\LSL\\%s_MOBI', list_of_files(1).name);

mobilab.allStreams = dataSourceXDF(path_to_file, path_new_folder);

exported_EEG = mobilab.allStreams().export2eeglab([1 2]);

