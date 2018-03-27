function outArray = annoArray(anns, markers, last)

% This function returns a cell array containing annotations for each sample
% of a run. The inputs are the annotations at sample markers. The last is
% the duration of the final annotation, as the markers only provide the
% start time.

outArray = {};
for i = 1:(length(anns)-1)
    for j = 1:markers(i+1)
        outArray{end+1} = anns{i};
    end
end

for i = 1:(160 * last)
    outArray{end+1} = anns{end};
end