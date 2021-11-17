%% Load Power matrix of electrodes vs frequencies (45)

psd_analysis_til



%% Plotting avg of subject per role and condition

% collect all speaker/listener files
Power_speaker = Power_mat(strcmp({Power_mat.role}, 'S'));
Power_listener = Power_mat(strcmp({Power_mat.role}, 'L'));


% collect each condition from speaker role
Speaker_rs1 = Power_speaker(strcmp({Power_speaker.cond}, 'RS1'));
Speaker_ns = Power_speaker(strcmp({Power_speaker.cond}, 'NS'));
Speaker_rs2 = Power_speaker(strcmp({Power_speaker.cond}, 'RS2'));
Speaker_es = Power_speaker(strcmp({Power_speaker.cond}, 'ES'));
Speaker_rs3 = Power_speaker(strcmp({Power_speaker.cond}, 'RS3'));
% collect each condition from listener role
Listener_rs1 = Power_listener(strcmp({Power_listener.cond}, 'RS1'));
Listener_ns = Power_listener(strcmp({Power_listener.cond}, 'NS'));
Listener_rs2 = Power_listener(strcmp({Power_listener.cond}, 'RS2'));
Listener_es = Power_listener(strcmp({Power_listener.cond}, 'ES'));
Listener_rs3 = Power_listener(strcmp({Power_listener.cond}, 'RS3'));

% calculate avg for each condition of speaker
speaker_rs1_cat = cat(3,Speaker_rs1.power);
speaker_ns_cat = cat(3,Speaker_ns.power);
speaker_rs2_cat = cat(3,Speaker_rs2.power);
speaker_es_cat = cat(3,Speaker_es.power);
speaker_rs3_cat = cat(3,Speaker_rs3.power);

speaker_rs1_avg = mean(speaker_rs1_cat,3);
speaker_ns_avg = mean(speaker_ns_cat,3);
speaker_rs2_avg = mean(speaker_rs2_cat,3);
speaker_es_avg = mean(speaker_es_cat,3);
speaker_rs3_avg = mean(speaker_rs3_cat,3);

% calculate avg for each condition of listener
listener_rs1_cat = cat(3,Listener_rs1.power);
listener_ns_cat = cat(3,Listener_ns.power);
listener_rs2_cat = cat(3,Listener_rs2.power);
listener_es_cat = cat(3,Listener_es.power);
listener_rs3_cat = cat(3,Listener_rs3.power);

listener_rs1_avg = mean(listener_rs1_cat,3);
listener_ns_avg = mean(listener_ns_cat,3);
listener_rs2_avg = mean(listener_rs2_cat,3);
listener_es_avg = mean(listener_es_cat,3);
listener_rs3_avg = mean(listener_rs3_cat,3);


speaker_ns_theta = mean(speaker_ns_avg(:,4:8),2);
speaker_ns_alpha = mean(speaker_ns_avg(:,9:13),2);
speaker_ns_beta1 = mean(speaker_ns_avg(:,19:23),2);
speaker_ns_beta2 = mean(speaker_ns_avg(:,15:31),2);

speaker_es_theta = mean(speaker_es_avg(:,4:8),2);
speaker_es_alpha = mean(speaker_es_avg(:,9:13),2);
speaker_es_beta1 = mean(speaker_es_avg(:,19:23),2);
speaker_es_beta2 = mean(speaker_es_avg(:,15:31),2);

listener_ns_theta = mean(listener_ns_avg(:,4:8),2);
listener_ns_alpha = mean(listener_ns_avg(:,9:13),2);
listener_ns_beta1 = mean(listener_ns_avg(:,19:23),2);
listener_ns_beta2 = mean(listener_ns_avg(:,15:31),2);

listener_es_theta = mean(listener_es_avg(:,4:8),2);
listener_es_alpha = mean(listener_es_avg(:,9:13),2);
listener_es_beta1 = mean(listener_es_avg(:,19:23),2);
listener_es_beta2 = mean(listener_es_avg(:,15:31),2);

% theta
data1 = speaker_ns_theta;
data2 = listener_ns_theta;
data3 = speaker_es_theta;
data4 = listener_es_theta;

max_psd = max(max([data1 data2 data3 data4]));
figure()
subplot(2,2,1)
topoplotIndie(data1(:,1),EEG.chanlocs)
caxis([0 max_psd])
colorbar
title('Speaker Neutral')
subplot(2,2,2)
topoplotIndie(data2(:,1),EEG.chanlocs)
caxis([0 max_psd])
colorbar
title('Listener Neutral')
subplot(2,2,3)
topoplotIndie(data3(:,1),EEG.chanlocs)
caxis([0 max_psd])
colorbar
title('Speaker Emotional')
subplot(2,2,4)
topoplotIndie(data4(:,1),EEG.chanlocs)
caxis([0 max_psd])
colorbar
title('Listener Emotional')
sgtitle('Theta') 

%alpha
data1 = speaker_ns_alpha;
data2 = listener_ns_alpha;
data3 = speaker_es_alpha;
data4 = listener_es_alpha;

max_psd = max(max([data1 data2 data3 data4]));
figure()
subplot(2,2,1)
topoplotIndie(data1(:,1),EEG.chanlocs)
caxis([0 max_psd])
colorbar
title('Speaker Neutral')
subplot(2,2,2)
topoplotIndie(data2(:,1),EEG.chanlocs)
caxis([0 max_psd])
colorbar
title('Listener Neutral')
subplot(2,2,3)
topoplotIndie(data3(:,1),EEG.chanlocs)
caxis([0 max_psd])
colorbar
title('Speaker Emotional')
subplot(2,2,4)
topoplotIndie(data4(:,1),EEG.chanlocs)
caxis([0 max_psd])
colorbar
title('Listener Emotional')
sgtitle('Alpha') 


%beta1
data1 = speaker_ns_beta1;
data2 = listener_ns_beta1;
data3 = speaker_es_beta1;
data4 = listener_es_beta1;

max_psd = max(max([data1 data2 data3 data4]));
figure()
subplot(2,2,1)
topoplotIndie(data1(:,1),EEG.chanlocs)
caxis([0 max_psd])
colorbar
title('Speaker Neutral')
subplot(2,2,2)
topoplotIndie(data2(:,1),EEG.chanlocs)
caxis([0 max_psd])
colorbar
title('Listener Neutral')
subplot(2,2,3)
topoplotIndie(data3(:,1),EEG.chanlocs)
caxis([0 max_psd])
colorbar
title('Speaker Emotional')
subplot(2,2,4)
topoplotIndie(data4(:,1),EEG.chanlocs)
caxis([0 max_psd])
colorbar
title('Listener Emotional')
sgtitle('Beta 18-22 Hz') 

%beta2
data1 = speaker_ns_beta2;
data2 = listener_ns_beta2;
data3 = speaker_es_beta2;
data4 = listener_es_beta2;

max_psd = max(max([data1 data2 data3 data4]));
figure()
subplot(2,2,1)
topoplotIndie(data1(:,1),EEG.chanlocs)
caxis([0 max_psd])
colorbar
title('Speaker Neutral')
subplot(2,2,2)
topoplotIndie(data2(:,1),EEG.chanlocs)
caxis([0 max_psd])
colorbar
title('Listener Neutral')
subplot(2,2,3)
topoplotIndie(data3(:,1),EEG.chanlocs)
caxis([0 max_psd])
colorbar
title('Speaker Emotional')
subplot(2,2,4)
topoplotIndie(data4(:,1),EEG.chanlocs)
caxis([0 max_psd])
colorbar
title('Listener Emotional')
sgtitle('Beta 14-30 Hz') 

% % calc colorbar limits
% nallavg_cat = cat(1,...
%     speaker_rs1_avg,speaker_ns_avg,speaker_rs2_avg,speaker_es_avg,speaker_rs3_avg,...
%     listener_rs1_avg, listener_ns_avg,listener_rs2_avg,listener_es_avg,listener_rs3_avg);
% ncmin = min(nallavg_cat,[],'all');
% ncmax = max(nallavg_cat,[],'all');
% nclims = [ncmin ncmax];
% 
% 
% figure();
% s1=subplot(2,5,1);
% imagesc(speaker_rs1_avg,nclims);
% title('Condition = RS1');
% xlabel('freq (Hz)');
% ylabel({'Speaker','','','electrode'});
% yticks(1:EEG.nbchan);
% yticklabels({EEG.chanlocs.labels});
% figsize=get(s1,'position');
% set(s1,'position',figsize);
% 
% s2=subplot(2,5,2);
% imagesc(speaker_ns_avg,nclims);
% title('Condition = NS');
% xlabel('freq (Hz)');
% ylabel('electrode');
% yticks(1:EEG.nbchan);
% yticklabels({EEG.chanlocs.labels});
% figsize=get(s2,'position');
% set(s2,'position',figsize);
% 
% s3=subplot(2,5,3);
% imagesc(speaker_rs2_avg,nclims);
% title('Condition = RS2');
% xlabel('freq (Hz)');
% ylabel('electrode');
% yticks(1:EEG.nbchan);
% yticklabels({EEG.chanlocs.labels});
% figsize=get(s3,'position');
% set(s3,'position',figsize);
% 
% s4=subplot(2,5,4);
% imagesc(speaker_es_avg,nclims);
% title('Condition = ES');
% xlabel('freq (Hz)');
% ylabel('electrode');
% yticks(1:EEG.nbchan);
% yticklabels({EEG.chanlocs.labels});
% figsize=get(s4,'position');
% set(s4,'position',figsize);
% 
% s5=subplot(2,5,5);
% imagesc(speaker_rs3_avg,nclims);
% title('Condition = RS3');
% xlabel('freq (Hz)');
% ylabel('electrode');
% yticks(1:EEG.nbchan);
% yticklabels({EEG.chanlocs.labels});
% figsize=get(s5,'position');
% 
% cb=colorbar('location','eastoutside');
% cb.Label.String = 'Log Power Spectral Density 10*log_{10}(\muV^{2}/Hz)';
% set(s5,'position',figsize);
% 
% 
% s6=subplot(2,5,6);
% imagesc(listener_rs1_avg,nclims);
% xlabel('freq (Hz)');
% ylabel({'Listener','','','electrode'});
% yticks(1:EEG.nbchan);
% yticklabels({EEG.chanlocs.labels});
% figsize=get(s6,'position');
% set(s6,'position',figsize);
% 
% s7=subplot(2,5,7);
% imagesc(listener_ns_avg,nclims);
% xlabel('freq (Hz)');
% ylabel('electrode');
% yticks(1:EEG.nbchan);
% yticklabels({EEG.chanlocs.labels});
% figsize=get(s7,'position');
% set(s7,'position',figsize);
% 
% s8=subplot(2,5,8);
% imagesc(listener_rs2_avg,nclims);
% xlabel('freq (Hz)');
% ylabel('electrode');
% figsize=get(s8,'position');
% set(s8,'position',figsize);
% 
% s9=subplot(2,5,9);
% imagesc(listener_es_avg,nclims);
% xlabel('freq (Hz)');
% ylabel('electrode');
% yticks(1:EEG.nbchan);
% yticklabels({EEG.chanlocs.labels});
% figsize=get(s9,'position');
% set(s9,'position',figsize);
% 
% s10=subplot(2,5,10);
% imagesc(listener_rs3_avg,nclims);
% xlabel('freq (Hz)');
% ylabel('electrode');
% yticks(1:EEG.nbchan);
% yticklabels({EEG.chanlocs.labels});
% figsize=get(s10,'position');
% 
% cb=colorbar('location','eastoutside');
% cb.Label.String = 'Log Power Spectral Density 10*log_{10}(\muV^{2}/Hz)';
% set(s10,'position',figsize);



%% plot bands with topo

% NS = (speaker_ns_avg + listener_ns_avg)/2;
% ES = (speaker_es_avg + listener_es_avg)/2;
% 
% S = (speaker_ns_avg + speaker_es_avg)/2;
% L = (listener_ns_avg + listener_es_avg)/2;
% 
% NS_theta = mean(NS(:,4:8),2);
% NS_alpha = mean(NS(:,9:13),2);
% NS_beta1 = mean(NS(:,19:23),2);
% NS_beta2 = mean(NS(:,15:31),2);
% 
% ES_theta = mean(ES(:,4:8),2);
% ES_alpha = mean(ES(:,9:13),2);
% ES_beta1 = mean(ES(:,19:23),2);
% ES_beta2 = mean(ES(:,15:31),2);
% 
% S_theta = mean(S(:,4:8),2);
% S_alpha = mean(S(:,9:13),2);
% S_beta1 = mean(S(:,19:23),2);
% S_beta2 = mean(S(:,15:31),2);
% 
% L_theta = mean(L(:,4:8),2);
% L_alpha = mean(L(:,9:13),2);
% L_beta1 = mean(L(:,19:23),2);
% L_beta2 = mean(L(:,15:31),2);
% 
% 
% data1 = ES_theta;
% data2 = NS_theta;
% max_psd = max(max([data1 data1]));
% figure(5)
% subplot(2,1,1)
% topoplotIndie(data1(:,1),EEG.chanlocs)
% caxis([0 max_psd])
% colorbar
% subplot(2,1,2)
% topoplotIndie(data2(:,1),EEG.chanlocs)
% caxis([0 max_psd])
% colorbar

%%  extract ind psd

% cd D:\Dropbox\Projects\Emotional_Sharing_EEG\EEG_Data\powerIND_data
% for i=1:370
%     csvwrite(sprintf('%s_%s_%s.csv', Power_mat(i).subj, Power_mat(i).role, Power_mat(i).cond), Power_mat(i).power)
% end


