% files_info = [];
% for file_idx = 1:size(list_of_files,1)
%     d = load_xdf(list_of_files(file_idx).name);
%     lsl_fields = [];
% for lsl_field = 1:size(d,2)
%     lsl_fields = [lsl_fields size(d{1,lsl_field}.time_series,2)];
% end
%     lsl_fields_sorted = sort(lsl_fields, 'descend');
%     files_info(file_idx,1) = lsl_fields_sorted(1);
%     files_info(file_idx,2) = lsl_fields_sorted(2);
%     
%     files_info(file_idx,3) = lsl_fields(1);
%     files_info(file_idx,4) = lsl_fields(2);
%     files_info(file_idx,5) = lsl_fields(3);
%     files_info(file_idx,6) = lsl_fields(4);
%     files_info(file_idx,7) = lsl_fields(5);
%     files_info(file_idx,8) = lsl_fields(6);
%     
%     
% %     if size(d{1,1}.time_series,2) > 150000
% %         files_correct(file_idx) = 1;
% %     else
% %         files_correct(file_idx) = 0;
% %         files_incorrect = [files_incorrect file_idx];
% %     end
% end
% 
% files_info = struct();
% for file_idx = 1:size(list_of_files,1)
%     
%     d = load_xdf(list_of_files(file_idx).name);
%     sub1 = list_of_files(file_idx).name(5:7);
%     sub2 = list_of_files(file_idx).name(10:12);
%     for lsl_field = 1:size(d,2)
%         if size(d{1,lsl_field}.info.name,2) <= 15
%             %d{1,lsl_field}.info.name = d{1,lsl_field}.info.name(1:14);
%             if contains(d{1,lsl_field}.info.name,sub1)
%                 sub1_field = lsl_field;
%             elseif  contains(d{1,lsl_field}.info.name,sub2)
%                 sub2_field = lsl_field;
%             end
% %         else
% %             if contains(d{1,lsl_field}.info.name,sub1)
% %                 sub1_field = lsl_field;
% %             elseif  contains(d{1,lsl_field}.info.name,sub2)
% %                 sub2_field = lsl_field;
% %             end
%         end
%     end
%     files_info(file_idx).sub1_field = sub1_field;
%     files_info(file_idx).sub2_field = sub2_field;
%     files_info(file_idx).name = list_of_files(file_idx).name;
%     files_info(file_idx).size_sub1 = size(d{1,sub1_field}.time_series,2);
%     files_info(file_idx).size_sub2 = size(d{1,sub2_field}.time_series,2);
%     files_info(file_idx).name_sub1 = d{1,sub1_field}.info.name;
%     files_info(file_idx).name_sub2 = d{1,sub2_field}.info.name;
%     
% end








%     % load xdf file with both datasets + video frames
%     d = load_xdf(list_of_files(eeg_file).name);
%     %separate subject numbers 
%     sub1 = list_of_files(eeg_file).name(5:7);
%     sub2 = list_of_files(eeg_file).name(10:12);
%     % for loop to check in which fields of the data both subjects are
%     % stored
%     for lsl_field = 1:size(d,2)
%         if size(d{1,lsl_field}.info.name,2) <= 15
%             %d{1,lsl_field}.info.name = d{1,lsl_field}.info.name(1:14);
%             if contains(d{1,lsl_field}.info.name,sub1)
%                 sub1_field = lsl_field;
%             elseif  contains(d{1,lsl_field}.info.name,sub2)
%                 sub2_field = lsl_field;
%             end
%         end
%     end
% %load template subject into eeglab template
% eeg_sub1 = pop_loadxdf('SNS_085L_086S_N_ES.xdf');
% 
% % exchange data in template with data from xdf file
% eeg_sub1.data = d{1,sub1_field}.time_series;
% eeg_sub1.data = eeg_sub1.data(:,1:150001);
% eeg_sub1.pnts = 150001;
% eeg_sub1.times = eeg_sub1.times(1:150001);
% eeg_sub1.data = eeg_sub1.data(:,1:150001);
% eeg_sub1.xmax = 300;
% eeg_sub1.filename = list_of_files(eeg_file).name;
% 
% % copy the eeglab template for the sub2 and replace sub1 data with sub2
% % data
% eeg_sub2 = eeg_sub1;
% eeg_sub2.data = d{1,sub2_field}.time_series;
% eeg_sub2.data = eeg_sub2.data(:,1:150001);