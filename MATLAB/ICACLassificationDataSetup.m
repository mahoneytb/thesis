% ICA of test set - prep for classifier training
clear
load('testW.mat')
load('testS.mat')
load('filterLabelsNew.mat')
labelSet = [newLabel == 'N'; newLabel == 'A'];

%% Straight input of each weight
sampleSet = [];
S = [];
fbands = [];
samPerHert = 129/80; %length(f)/(fs/2)
delt = 1:floor(4*samPerHert);
theta = delt(end):floor(8*samPerHert);
alpha = theta(end):floor(16*samPerHert);
beta = alpha(end):floor(32*samPerHert);
gamma = beta(end):floor(80*samPerHert);

for subject = 1:20
    for sample = 1:10
        for c = 1:15
            sampleSet = [sampleSet, squeeze(Wfull(subject, sample, :, c));];
            
            newS = squeeze(Sfull(subject, sample, c, :));
            S = [S, newS];
            
            f = pwelch(newS, 60, 45, 256, 160);
            
            fbands = [fbands, [mean(f(delt)); mean(f(theta)); mean(f(alpha)); ...
                                mean(f(beta)); mean(f(gamma))]];
        end
    end
end

% Normalised weights
for i = 1:length(sampleSet)
    if min(sampleSet(:, i)) < 0
        sampleSet(:, i) = sampleSet(:, i) + abs(min(sampleSet(:, i)));
    else
        sampleSet(:, i) = sampleSet(:, i) - min(sampleSet(:, i));
    end
    sampleSet(:, i) = sampleSet(:, i) / max(sampleSet(:, i));
end

%% Other parameters
temp = sampleSet;
sampleSet = [];
outer = [43, 41, 39, 30, 25, 22, 23, 24, 29, 38, 40, 44, 42, 46, 55, 60, ...
            63, 62, 64, 61, 56, 47, 45];
inner = [1:21, 26:28, 31:37, 48:54, 57:59];
for i = 1:length(temp)
    params = temp(:, i);
    
    sampleSet = [sampleSet, [kurtosis(params); var(params); mean(params); ...
                                mean(params(22:29)); mean(params(outer)); ...
                                mean(params(inner)); max(params(outer)); ...
                                %fbands(:, i); mean(params(22:29))/mean(params); ...
                                skewness(params)]];
                            
    
end
    
%%


