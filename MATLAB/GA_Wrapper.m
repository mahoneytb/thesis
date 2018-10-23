% Lets get down to bussiness, GA style
% Load the data
clear
load('finalAnnSet.mat')
load('finalFeatureSet.mat')
load('goodFeatureSet.mat')  % bench set
load('goodsvm3.mat')
%%

remove = 1; % 0
idx = [];
for i = 1:length(anList)
    if (isequal(anList(i), {'T0'}))
        if (remove)
            idx = [idx i];
        end
        %remove = ~remove;
    end
end
anList(idx) = [];
features(:, idx) = [];

current = anList(1);
remove = [];
add1 = 1;
for i = 2:length(anList)
    if isequal(anList(i), anList(i-1))
        remove = [remove, i];
    end
end

anList(remove) = [];
features(:, remove) = [];

features = informedData(features);
    
gArray = [];
BIG = 0;
tracking = [];
for seed = 1%:100
    fprintf("Seed %d\n", seed)
    %rng(seed)
    tic
    N_FEATURES = size(features, 1);
    N_SETS = 8;
    gStruct.children = N_SETS;
    pool = zeros(N_FEATURES, N_SETS);
    
    % Initialise children
    %pool(:, 1) = goodsvm;   %include feature set found using bench
    rng('shuffle')
    for i = 1:N_SETS
        n = unidrnd(N_FEATURES);
        include = randsample(N_FEATURES, n);
        pool(include, i) = 1;
    end
    % keep in mind you're now only using 1/5 of set
    feature_set = features;
    an_set = anList;
    scores = zeros(1, N_SETS);
    ratio = zeros(N_SETS, 2);
    gen = 1;
    NUM_GENS = 1000 ;
    gStruct.gens = NUM_GENS;
    while (gen < NUM_GENS)
        fprintf('Beggining generation %d\n', gen)
        %% Compute the score
        % fprintf('Computing score...\n')
        start = 3;
        if gen == 1, start = 1; end
        for i = start:N_SETS
            % Compute the score of the subset
            scores(i) = SVM(feature_set, an_set, pool(:, i));
            % fprintf('Scored %d of 8\n', i);
        end
        % if gen == (NUM_GENS-1), break; end
        
        %0.0001 0.234 with 300
        error = scores - sum(pool).*0.005;
        print = [error; sum(pool); scores];
        fprintf('Candidates:\n')
        disp(print)
        tracking = [tracking, print(:,1)];
        
        %% Select highest scorers for next gen
        tempPool = pool;
        tempScores = scores;

        % 4 of the highest, keep score for elite children
        [M, I] = min(tempScores);
        BIG = scores(1);
        % fprintf('Scores:   %5.4f %5.4f %5.4f %5.4f %5.4f %5.4f %5.4f %5.4f\n', scores)
   
        for i = 1:4, pool(:, i) = tempPool(:, I); end
        scores(1) = tempScores(I);
        tempScores(I) = [];
        tempPool(:, I) = [];

        % 2 of the second highest, keep score for elite children
        [M, I] = min(tempScores);
        for i = 5:6, pool(:, i) = tempPool(:, I); end
        scores(2) = tempScores(I);
        tempScores(I) = [];
        tempPool(:, I) = [];   

        % 2 of the third highest
        [M, I] = min(tempScores);
        for i = 7:8, pool(:, i) = tempPool(:, I); end

        %% Elite child - pass on the top 2 performing parents
    %     fprintf('Selecting elite children...\n')
        newPool = pool;
        newPool(:, 2) = pool(:, 5);

        %% Perform crossover
        % Try 4 crossover children
        % fprintf('Performing crossover...\n')
        for child = 3:8
            rng('shuffle')
            % find two different parents at random
            p1 = unidrnd(8);
            par1 = pool(:, p1);
            p2 = unidrnd(8);
            par2 = pool(:, p2);
            while (par2==par1)
                p2 = unidrnd(8);
                par2 = pool(:, p2);
            end
            % randomly pass on their attributes
            for i = 1:N_FEATURES
                if (par1(i) ==par2(i))
                    newPool(i, child) = par1(i);
                else
                    coin = unidrnd(2);
                    if coin == 1
                        newPool(i, child) = par1(i);
                    else
                        newPool(i, child) = par2(i);
                    end
                end
            end
        end

        %% Perform mutation
    %     fprintf('Performing mutation...\n')
        for child = 3:8
            % Pick random parent
            p = unidrnd(8);
            % Roll uniform random 100 sided dice
            m = unidrnd(50*ones(N_FEATURES, 1));
            m = (m == 1);
            % Mutate 1 in 100
            newPool(:, child) = xor(pool(:, p), m);
        end

        pool = newPool;
        gen = gen + 1;
        
        if gen == NUM_GENS
            fprintf('Best: %5.4f\n', scores(1));
        end
    end
    gStruct.pool = pool;
    gStruct.scores = scores;
    gStruct.best = min(scores);
    gStruct.time = toc;
    gStruct.seed = seed;
    gArray = [gArray gStruct];
end
    
    



