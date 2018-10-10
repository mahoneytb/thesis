used featureExtraction.m instead!!!

% combine data into stream, not samples
% this is because events are timestamped so I need to access a particual
% period about a sample. 

% 2 sec prior 1.5 prior 1 sec prior 0.5 prior 0.5 post   1 post
%<-----------|---------|-----------|---------|---------|-------->
% Each sample will include frequency band info from t = [-2 to -1.5], [-1.5 
% to -1], [-1 to -0.5], [-0.5 to 0], [0 to 0.5] and [0.5 to 1]

% for training, event classes will be defined about the event (+-0.05)

% % Produce x streams of data
stream = zeros(109, 64, 19441);
for sub = 1:109
    if (sub~=88)&&(sub~=92)&&(sub~=100)
        fname = sprintf('Subject%dFilteredSamples.mat', sub);
        load(fname)
        stream(sub, :, 1:321) = subjectData(1, :, :);
        for samp = 2:240
            t0 = (samp-2)*80 + 322;
            tend = t0 + 79;
            stream(sub, :, t0:tend) = subjectData(samp, :, (end-79):end);
        end
    end
end
%       
%% Create true samples
% we need to take 'true event' samples around the event point as we only 
% sample every 0.1 sec. On line sampling may pickup the ERD/S in its
% early or late stage. For each label, we will take 3 samples about the
% point and call them true.
formLS
load('Task4Anns.mat')
final_labels = [];
final_features = [];
fs = 160;
removed = [43, 41, 39, 30, 25, 22, 23, 24, 29, 38, 40, 44, 42, 46, 55, 60, ...
            63, 62, 64, 61, 56, 47, 45];
filts = creatFilts();
for sub = 1:109
    disp(sub)
    if (sub~=88)&&(sub~=92)&&(sub~=100)
        ann = Anns{1, sub};
        Annos = ann{1, 1};
        Times = ann{1, 2};
        for i = 1:length(Times)
            if ~isequal(Annos{1, i}, 'T0')
                % Separate into 3 overlapping x samples about the label
                t0 = Times(i);
                xbands = [((t0-8)-2*fs):((t0-8)+fs);
                          (t0-2*fs):(t0+fs);
                          ((t0+8)-2*fs):((t0+8)+fs)];
                for j = 1:3
                    % Section data
                    sample = squeeze(stream(sub, :, xbands(j, :)));
                    % Perform surface laplacian
                    Lsample = L*sample;
                    Lsample(removed, :) = [];
                    final_features = [final_features; getFeatures2(Lsample, filts)];
                    final_labels = [final_labels; Annos{1, i}];
                end
            end
        end
    end
end