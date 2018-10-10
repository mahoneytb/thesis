% Script to remove artefacts from entire dataset (task4)
clear;
load('testRecord.mat')
load('bestNet.mat')

%%
% Create filters
fs = 160;
fc_low = 79;
fc_high = 1;
fc_notch = [58 62];

% Create low pass
[b_low,a_low] = butter(5,fc_low/(fs/2));
H1=dfilt.df2t(b_low,a_low);

% Create high pass
[b_high,a_high] = butter(5,fc_high/(fs/2),'high');
H2=dfilt.df2t(b_high,a_high);

% Create 60Hz notch
[b_notch,a_notch] = butter(2,fc_notch/(fs/2),'stop');
H3=dfilt.df2t(b_notch,a_notch);

% Combine filters
Hcas=dfilt.cascade(H1,H2,H3);
% Hcas.freqz()

%% Get ICs for all samples - sampled at 2Hz, sample width = 2 seconds
for i = 1:20 %109
    for j = 1:240 %6
        fprintf('Test Sample: %d of 1200 for Subject: %d \n', j, i);
        % Resample every 0.5 seconds
        t0 = (j-1)*fs/2 + 1;
        % Sample over 2 second period
        tEnd = t0 + 2*fs;
        data = squeeze(testrecord(i, 1:64, t0:tEnd));
        filtData = filter(Hcas, data, 2);
        [S, W] = ICA(filtData, 15);
        Sfull(i, j, :, :) = S;
        Wfull(i, j, :, :) = W;
    end
end

%%
% Time specifications:
Fs = 160;                      % samples per second
dt = 1/Fs;                     % seconds per sample
StopTime = 5;                  % seconds
t = (0:dt:StopTime-dt)';
N = 321;               % 321
SfullRemoved = Sfull;

label = [];
artefactsRemoved = [];
count = 0;
%%
% Detect artefacts and remove
for subject = 1:20
    for sample = 1:240
        fprintf('Subject: %d Sample: %d\n', subject, sample);
        for c = 1:15
            W = squeeze(Wfull(subject, sample, :, c));
            S = squeeze(Sfull(subject, sample, c, :));
            features = getFeatures(W, S);
            y = bestNet(features);
            if y == 'A'
                SfullRemoved(subject, sample, c, :) = 0;
                count = count + 1;
            end
        end
        artefactsRemoved = [artefactsRemoved, count];
        count = 0;
    end
end
            