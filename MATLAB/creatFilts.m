function filts = creatFilts()
%formLS
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