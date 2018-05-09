% Results
% 8 8 best with 66% 0.05 learning rate
% run this ICAClassificationDataSetup
% when plotting - the means, skewness,  are well separated
for i = 1:8
    for j = 1:8
        if i ~= j
            figure()
            gscatter(sampleSet(i,:)',sampleSet(j,:)',newLabel','br','xo')
            xlabel(sprintf('%d', i))
            ylabel(sprintf('%d', j))
        end
    end
end


