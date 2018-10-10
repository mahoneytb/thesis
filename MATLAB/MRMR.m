% Compute MRMR
% https://ieeexplore-ieee-org.ezproxy.library.uq.edu.au/stamp/stamp.jsp?tp=&arnumber=1453511
function [score, redundancy_lookup] = MRMR(data, labels, sequence, lookup)
len = size(data, 1);            % Full number of features
N_FEATURES = sum(sequence);     % Number of features in this sequence

%might need to scale data as apparantly MI algorithm rounds to integers...
data = round(10000*data);
relevence = zeros(1, len);
fprintf('Computing relevence...\n')
count = 1;
% For every feature, check if in sequence, compute relevence and store for
% averaging
for i = 1:len
    if (sequence(i) == 1)
        relevence(count) = mutualinfo(data(i, :), int8(ismember(labels, 'T0')));
        count = count + 1;
    end
end
relevence = mean(relevence);

fprintf('Computing redundancy...\n')
redundancy = zeros(1, (N_FEATURES^2 + N_FEATURES)/2);
count = 1;
% For every feature, check if in sequence
for i = 1:len
    if sequence(i) == 1
        % Check if every other feature is in sequence
        for j = (i+1):len
            if sequence(j) == 1
                % If both are, check if redundancy has been computed before
                % If so, store previously computed value. Otherwise compute
                % redundancy and store in lookup table
                if lookup(i, j) ~= 0
                    redundancy(count) = lookup(i, j);
                else
                    redundancy(count) = mutualinfo(data(i, :), data(j, :));
                    lookup(i, j) = redundancy(count);
                    lookup(j, i) = redundancy(count);
                end
                fprintf('%d redundancy left\n', N_FEATURES - count);
                count = count + 1;
            end
        end
    end
end
redundancy = mean(redundancy);

score = relevence - redundancy;
redundancy_lookup = lookup;