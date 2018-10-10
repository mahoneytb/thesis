% This function includes only data we believe to be important. ie. Certain
% channels, times and frequencies
function smallData = informedData(bigData)

% data is sorted such that it is 6 time samples * 61 channels * 7
% frequencies

N_FEATURES = 2562;

% keep only frequencies from mu alpha and beta bands
% From the top, the feature set is sorted into bands (7 bands)
perBand = N_FEATURES/7;

bigData(1:perBand*2, :) = []; %perBand*2
bigData(end-perBand*2+1:end, :) = []; %perband*4

% keep only channels located in the motor region associated with hand
% control
removed = [41, 39, 30, 25, 22, 23, 24, 29, 38, 40, 42, 46, 55, 60, ...
            63, 62, 61, 56, 47, 45];
bigRemoved = [];
for f = 0:2
    for i = removed
        if i>44
            bigRemoved = [bigRemoved, ((i-2)*6-5+f*perBand):((i-2)*6+f*perBand)];
        else
            bigRemoved = [bigRemoved, (i*6-5+f*perBand):(i*6+f*perBand)];
        end
    end
end
bigData(bigRemoved, :) = [];
smallData = bigData;