% This function converts the raw data into samples
% input is 109*65*20000
% output is 109*240*64*321 - 240 samples blocks of 321 individual samples
% ie. 2 second samples sampled every 0.5 seconds
function out = sampleRaw(raw)

out = zeros(109, 240, 64, 321);
for i = 1:109
    for j = 1:240
        start = 80*(j-1) + 1;
        fin = start + 320;
        out(i, j, :, :) = squeeze(raw(i, 1:64, start:fin));
    end
end

