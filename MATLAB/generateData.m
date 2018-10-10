%% Read .edf data and .txt events for storage
% All things say task 4 BUT HAVE BEEN TAKEN FROM TASK 2!! WHICH IS SET 4!!
% MORE DATA CAN BE RETRIEVED FROM SETS 8 AND 12!!
clear
s = [0 0];
record = [];

% Add every subject recording to variable record
for k = 1:20 %109
    if k < 10
        filename = sprintf('physionetData/S00%d/S00%dR08.edf', k, k);
        annfilename = sprintf('physionetData/annotations/S00%dR08ann.txt', k);
    elseif k < 100
        filename = sprintf('physionetData/S0%d/S0%dR08.edf', k, k);
        annfilename = sprintf('physionetData/annotations/S0%dR08ann.txt', k);
    else
        filename = sprintf('physionetData/S%d/S%dR08.edf', k, k);
        annfilename = sprintf('physionetData/annotations/S%dR08ann.txt', k);
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
        end
    end
    
    % Get the annotations
    fileID = fopen(annfilename);
    
    w = 1;
    d = [];
    a = {};
    while ~feof(fileID)
        if w == 2
            d = [d fscanf(fileID, '%d', 1)];
        elseif w == 3
            a{end + 1} = fscanf(fileID, '%s', 1);
        elseif w == 8
            last = fscanf(fileID, '%f', 1);
            w = 0;
        else fscanf(fileID, '%s', 1);
        end
        w = w + 1;
    end
    
    % Convert from ann duration to array of annotations for each sample
    % Anns{k} = annoArray(a, d, last);
    testAnns{k} = {a d last};
    
    testrecord(k, :, :) = r(:, 1:19680);
    disp(k)
end


    