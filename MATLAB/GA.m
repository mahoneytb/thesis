% Lets get down to bussiness, GA style
% Load the data
clear
load('finalAnnSet.mat')
load('finalFeatureSet.mat')
load('redundancyFinal.mat')
load('relevenceFinal.mat')
load('goodFeatureSet.mat')  % bench set
%%
gArray = [];
BIG = 0;
for seed = 1%:100
    %fprintf("Seed %d\n", seed)
    rng(seed)
    tic
    N_FEATURES = size(features, 1);
    N_SETS = 8;
    gStruct.children = N_SETS;
    pool = zeros(N_FEATURES, N_SETS);
    
    % Initialise children
    pool(featureList, 1) = 1;   %include feature set found using bench
    for i = 2:N_SETS
        n = unidrnd(N_FEATURES);
        include = randsample(N_FEATURES, n);
        pool(include, i) = 1;
    end
    % keep in mind you're now only using 1/5 of set
    feature_set = features;
    an_set = anList;
    scores = zeros(N_SETS, 1);
    ratio = zeros(N_SETS, 2);
    gen = 1;
    NUM_GENS = 2000;
    gStruct.gens = NUM_GENS;
    while BIG < 0.1
        if rem(gen, 10) == 0
            fprintf('Best: %d at gen: %d\n', BIG, gen)
        end
    %while (gen < NUM_GENS)
        % fprintf('Beggining generation %d\n', gen)
        %% Compute the score
        % fprintf('Computing score...\n')
        start = 3;
        if gen == 1, start = 1; end
        for i = start:N_SETS
            % Compute the score of the subset
            [scores(i), ratio(i, :)] = CORR(feature_set, an_set, ...
                pool(:, i), lookup, relevence);
            % fprintf('Scored %d of 8\n', i);
        end
        % if gen == (NUM_GENS-1), break; end

        %% Select highest scorers for next gen
        tempPool = pool;
        tempScores = scores;
        tempRatio = ratio;

        % 4 of the highest, keep score for elite children
        [M, I] = max(tempScores);
        BIG = scores(1);
        %fprintf('Children: %5.4f %5.4f %5.4f %5.4f %5.4f %5.4f %5.4f %5.4f\n', scores)
        for i = 1:4, pool(:, i) = tempPool(:, I); end
        scores(1) = tempScores(I);
        ratio(1, :) = tempRatio(I, :);
        tempScores(I) = [];
        tempPool(:, I) = [];
        tempRatio(I, :) = [];

        % 2 of the second highest, keep score for elite children
        [M, I] = max(tempScores);
        for i = 5:6, pool(:, i) = tempPool(:, I); end
        ratio(2, :) = tempRatio(I, :);
        scores(2) = tempScores(I);
        tempScores(I) = [];
        tempPool(:, I) = [];
        tempRatio(I, :) = [];       

        % 2 of the third highest
        [M, I] = max(tempScores);
        for i = 7:8, pool(:, i) = tempPool(:, I); end

        %% Elite child - pass on the top 2 performing parents
    %     fprintf('Selecting elite children...\n')
        newPool = pool;
        newPool(:, 2) = pool(:, 5);

        %% Perform crossover
        % Try 4 crossover children
        % fprintf('Performing crossover...\n')
        for child = 3:6
            p1 = unidrnd(8);
            p2 = unidrnd(8);
            g = unidrnd(N_FEATURES);
            newPool(1:g, child) = pool(1:g, p1);
            newPool(g:end, child) = pool(g:end, p2);
        end

        %% Perform mutation
    %     fprintf('Performing mutation...\n')
        for child = 2:8
            % Pick random parent
            p = unidrnd(8);
            % Roll uniform random 100 sided dice
            m = unidrnd(100*ones(N_FEATURES, 1));
            m = (m == 1);
            % Mutate 1 in 20
            newPool(:, child) = xor(pool(:, p), m);
        end

        pool = newPool;
        gen = gen + 1;
    end
    gStruct.pool = pool;
    gStruct.scores = scores;
    gStruct.best = max(scores);
    gStruct.time = toc;
    gStruct.seed = seed;
    gArray = [gArray gStruct];
end
    
    



