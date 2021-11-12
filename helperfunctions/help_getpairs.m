
% get two lists 
% - one for speakers
% - one for listeners
% in paired order ( Pair 1 = pairS(1) & pairL(1) etc.)
function [pairS, pairL] = help_getpairs()


    help_chose_analysisfolder % get filepath

    cd(filepath); %%TODO 


    % separate subjects into speaker and listener lists
    help_datacollector;

    pairS = {};
    pairL = {};

    for idx = 1:length(list_of_files)
        % split filenames
        sub_a =  list_of_files(idx).name(19:21);
        role_a = list_of_files(idx).name(22);
        sub_b =  list_of_files(idx).name(24:26);
        role_b = list_of_files(idx).name(27);


        switch role_a
            % if 1st subj is Speaker, assign to pairS...
            % and 2nd subject to pairL
            % keep members of lists unique
            case 'S'
                if(~ismember(sub_a,pairS))
                    pairS = [pairS;sub_a];
                    pairL = [pairL;sub_b];
                end
            % if 1st subj is Speaker, assign to pairL...
            % and 2nd subject to pairS
            % keep members of lists unique
            case 'L'
                if(~ismember(sub_a,pairL))
                    pairL = [pairL;sub_a];
                    pairS = [pairS;sub_b];
                end
        end
    end

    % check for pair consistency
    if(length(pairS) ~= length(pairL))
        error('Not equal amounts of speakers and listeners');
    end
end