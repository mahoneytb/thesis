%% Read .edf data and store as matlab file
clear
s = [0 0];
record = [];

% Add every subject recording to variable record
for k = 1:109
    if k < 10
        filename = sprintf('/physionetData/S00%d/S00%dR04.edf', k, k);
    elseif k < 100
        filename = sprintf('/physionetData/S0%d/S0%dR04.edf', k, k);
    else
        filename = sprintf('/physionetData/S%d/S%dR04.edf', k, k);
    end
    
    [hdr, r] = edfread(filename);
    s = size(record);
    
    % Pad the array
    if ~isequal(s, [0 0])
        if ~isequal(size(r), s(2:3))
            d = size(r, 2) - s(3);
            if d < 0
                r = padarray(r,[0 abs(d)], 0,'post');
            elseif d > 0
                r = padarray(record, [0 0 abs(d)], 0, 'post');
            end        
        end;
    end
    
    record(k, :, :) = r;
    disp(k)
end

%% Read events
    