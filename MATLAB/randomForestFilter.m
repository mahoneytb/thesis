% Random Forest - similar results
% run ICAClassificationDataSetup
%%
rng(1)

subset = randsample(3000, 2000);
Mdl = TreeBagger(100,sampleSet(:, subset)',newLabel(subset)','OOBPrediction','On',...
    'Method','classification', 'OOBPredictorImportance', 'On')

%%
remaining = [];
for i = 1:3000
    if sum(subset == i) == 0
        remaining = [remaining, i];
    end
end

y = predict(Mdl, sampleSet(:, remaining)');
ySet = [];
for i = 1:1000
    if y{i} == 'N'
        ySet = [ySet; [1, 0]];
    else
        ySet = [ySet; [0, 1]];
    end
end

plotconfusion(labelSet(:, remaining), ySet')

