% This function simply converts annotations from a list of anns and times
% into a string of anns for every sample (o.5 seconds)
function anList = getAnList(sub)

% we need to output an array 238 long (magic number). sampling starts from
% 2 secs in remember. Every 0.5 sec.
a = sub{1};
t = sub{2};
last = sub{3}*160;

indx = 1;
big = {};
anList = {};
% Create List
for i = 2:length(t)
    dif = t(i) - t(i-1);
    for j = 1:dif
        big{end+1} = a{i-1};
    end
end

% Append last anns
for j = 1:last
    big{end+1} = a{end};
end


for i = 1:238
    % Start 2 sec in, take the ann every 0.5 sec.
    anList{end+1} = big{(i-1)*80+320};
end
    



