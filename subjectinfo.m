%% function that returns subject, role, and condition of EEGset

function [subj,role,cond] = subjectinfo(setname)

info = split(setname,{'_',' '});

% select individual subjnr based on subjnr of this recording
if strcmp(info(9),'1')
    temp = char(info(4));
else 
    temp = char(info(5));
end

% return
subj = temp(1:end-1);
role = temp(end);
cond = char(info(7));