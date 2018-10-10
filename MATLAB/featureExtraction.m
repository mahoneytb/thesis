% final feature matrix (240x107)x64x(7x5)
% 88 92 and 100 don't work?

% Trying unfiltered data
% load('Task4Data.mat')
% data = sampleRaw(record);
features = [];
for sub = 1:20
    if (sub~=88)&(sub~=92)&(sub~=100)
        disp(sub)
        %subjectData = squeeze(data(sub, :, :, :));
        fname = sprintf('SubjectTest%dFilteredSamples.mat', sub);
        load(fname)
        % Gives me subjectData variable: 240 samples of 64 channels, 320
        % time samples. GetFeatures should return filtered and averaged
        % time values for every 240 samples.
        
        features = [features, getFeatures2(subjectData)];
    end
end
        
    