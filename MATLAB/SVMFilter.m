% SVM

subset = randsample(3000, 2000);

SVMModel = fitcsvm(sampleSet(:, subset)',newLabel(subset)','KernelFunction','rbf',...
    'KernelScale', 'auto', 'Standardize',true, 'BoxConstraint', inf);

remaining = [];
for i = 1:3000
    if sum(subset == i) == 0
        remaining = [remaining, i];
    end
end

[y,score] = predict(SVMModel,sampleSet(:, remaining)');

ySet = double([y == 'N', y == 'A']);

plotconfusion(labelSet(:, remaining), ySet')
