for i=1:37
    figure(i)
    plot(Listener_rs3(i).power')
end




EEG = pop_loadset();


% play with circular-circular and circular lineartmp_v = [];
for j=1:10000
    vector1 = [];
    vector2 = [];
    for i= 1:100
        mnval = -pi;
        mxval = pi;
        val1 = mnval + rand*(mxval-mnval);
        val2 = mnval + rand*(mxval-mnval);
        vector1 = [vector1 val1];
        vector2 = [vector2 val2];
        
    end
    tmp = circ_corrcl(vector1, vector2);
    tmp_v = [tmp_v tmp];
end