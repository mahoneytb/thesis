function output = getFeatures2(subjectData)

formLS
fs = 160;

% Only take the last 0.5 seconds and add to time shifting feature set.
tband = 241:320;

% Define frequency bands
fbands = [1, 4;      %Delta
          4, 7;      %Theta
          7, 12;     %Mu
          11, 15;    %Alpha
          15, 22;    %Beta
          22, 31;    %Beta High
          31, 50];   %Gamma

% Create filters
filts = [];
for i = 1:7
    d = fdesign.bandpass('N,F3dB1,F3dB2',10,fbands(i, 1),fbands(i, 2),fs);
    filts = [filts, design(d,'butter')];
end
features = zeros(243,64,7);
for s = 1:240
    sampleSet = [];
    for i = 1:7
        % Apply L surface transform
        L_out = squeeze(subjectData(s,:,:))' * L;
        fband = filter(filts(i), L_out);
        fband = fband.^2;
        
        % Take the whole first sample, from there only update the final 0.5
        % seconds of data (as it would in real time)
        if s == 1
            new = [mean(fband(1:80, :), 1); ...
                mean(fband(81:160, :), 1); ...
                mean(fband(160:240, :), 1); ...
                mean(fband(tband, :), 1)];
            features(1:4, :, i) = new;
        else
            new = mean(fband(tband, :), 1);
            features(s+3, :, i) = new;
        end        
    end
end
% features should end up as a 240x64x7 at this point

% Now we need to put the features in the form of ERPs
output = [];

% delete unnessisary channels
features(:, [43, 44, 64], :) = [];
for i = 6:243
    erp = features(i-5 : i, :, :);
    erp = erp - mean(features, 1);
    output = [output, erp(:)];
end

% 6 times * 61 channels * 7 frequencies
% loops through times first, then channels, then frequency
% output is: [time 1, channel 1, freq 1;
%             time 2, channel 1, freq 1;
%             ...
%             time 1, channel 2, freq 1;
%             time 2, channel 2, freq 1; 
%             ...
%             time 1, channel 1, freq 2; etc...


