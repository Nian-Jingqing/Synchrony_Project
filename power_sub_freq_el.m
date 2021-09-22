%% creates struct with power(over time) channel-frequency-matrix 
% for each subject/role/condition
%% Load data
% through helper skript
datacollector;

%% Poweranalysis  

% how many freqs to analyse
nfreqs = 45;

% create struct and fields
Power_mat = struct();
Power_mat.subj = [];
Power_mat.role = [];
Power_mat.cond = [];
Power_mat.power = [];


% loop over recordings
for i = 1:numel(list_of_files)
    % load next file
    EEG = pop_loadset('filename', list_of_files(i).name,'verbose','off');
    
    % get and save subject information
    [subj, role, cond] = subjectinfo(EEG.setname);
    Power_mat(i).subj = subj;
    Power_mat(i).role = role;
    Power_mat(i).cond = cond;
    
    % calculate power for each channel and frequency
    power = zeros(EEG.nbchan,nfreqs);
    for ch = 1:EEG.nbchan
        [spectra, freqs] = spectopo(EEG.data(ch,:,:),0,EEG.srate,'freqrange',[0 nfreqs],'plot','off','verbose','off');
        % only take the specified n freqs
        spectra = spectra(1:nfreqs);
        freqs = freqs(1:nfreqs);
        %save power of each channel
        power(ch,:) = spectra;
    end
    
    % save power/freq matrix in struct
    Power_mat(i).power = power;
    
    % display progress (0 to 1)
    disp(i/numel(list_of_files));
end


%% Plotting avg of subjects per role
% collect all speaker/listener files
Power_speaker = Power_mat(strcmp({Power_mat.role}, 'S'));
Power_listener = Power_mat(strcmp({Power_mat.role}, 'L'));

% calculate avg speaker power matrix
speaker_cat = cat(3,Power_speaker.power);
speaker_avg = mean(speaker_cat,3);
% calculate avg listener power matrix
listener_cat = cat(3,Power_listener.power);
listener_avg = mean(listener_cat,3);

%calculate colorbar limits
allavg_cat = cat(1,speaker_avg, listener_avg);
cmin = min(allavg_cat,[],'all');
cmax = max(allavg_cat,[],'all');
clims = [cmin cmax];

% Plotting
figure();

subplot(1,2,1);
imagesc(speaker_avg,clims);
title('Role = speaker');
xlabel('freq (Hz)');
ylabel('electrode');
colorbar;


subplot(1,2,2);
imagesc(listener_avg,clims);
title('Role = listener');
xlabel('freq (Hz)');
ylabel('electrode');

colorbar;

%% Plotting avg of subject per role and condition
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

% calc colorbar limits
nallavg_cat = cat(1,...
    speaker_rs1_avg,speaker_ns_avg,speaker_rs2_avg,speaker_es_avg,speaker_rs3_avg,...
    listener_rs1_avg, listener_ns_avg,listener_rs2_avg,listener_es_avg,listener_rs3_avg);
ncmin = min(nallavg_cat,[],'all');
ncmax = max(nallavg_cat,[],'all');
nclims = [ncmin ncmax];


figure();
subplot(2,5,1);
imagesc(speaker_rs1_avg,nclims);
title('Condition = RS1');
xlabel('freq (Hz)');
ylabel({'Speaker','','','electrode'});

subplot(2,5,2);
imagesc(speaker_ns_avg,nclims);
title('Condition = NS');
xlabel('freq (Hz)');
ylabel('electrode');

subplot(2,5,3);
imagesc(speaker_rs2_avg,nclims);
title('Condition = RS2');
xlabel('freq (Hz)');
ylabel('electrode');

subplot(2,5,4);
imagesc(speaker_es_avg,nclims);
title('Condition = ES');
xlabel('freq (Hz)');
ylabel('electrode');

subplot(2,5,5);
imagesc(speaker_rs3_avg,nclims);
title('Condition = RS3');
xlabel('freq (Hz)');
ylabel('electrode');
colorbar;


subplot(2,5,6);
imagesc(listener_rs1_avg,nclims);
xlabel('freq (Hz)');
ylabel({'Listener','','','electrode'});

subplot(2,5,7);
imagesc(listener_ns_avg,nclims);
xlabel('freq (Hz)');
ylabel('electrode');

subplot(2,5,8);
imagesc(listener_rs2_avg,nclims);
xlabel('freq (Hz)');
ylabel('electrode');

subplot(2,5,9);
imagesc(listener_es_avg,nclims);
xlabel('freq (Hz)');
ylabel('electrode');

subplot(2,5,10);
imagesc(listener_rs3_avg,nclims);
xlabel('freq (Hz)');
ylabel('electrode');
colorbar;



%%

