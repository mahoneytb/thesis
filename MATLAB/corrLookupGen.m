% Compute the lookup tables for Correlations: relevence and redundancy
load('finalAnnSet.mat')
load('finalFeatureSet.mat')
%%
% corr computes pairwise correlation (pearson) between columns of arg. We
% transpose 'features' so that samples are rows and features are columns
redundancyNew = abs(corr(features'));

%%
T0 = []; T1 = []; T2 = [];
for i=1:length(anList)
    T0 = [T0 isequal(anList(i), {'T0'})];
    T1 = [T1 isequal(anList(i), {'T1'})];
    T2 = [T2 isequal(anList(i), {'T2'})];
end

relevenceNew = [];
for i=1:size(features, 1)
    r0 = abs(corr([features(i, :); T0]'));
    r1 = abs(corr([features(i, :); T1]'));
    r2 = abs(corr([features(i, :); T2]'));
    r = mean([r0(2) r1(2) r2(2)]);
    relevenceNew = [relevenceNew r];
end
    



