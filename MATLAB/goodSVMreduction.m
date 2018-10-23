load('finalAnnSet.mat')
load('finalFeatureSet.mat')
load('goodsvm3.mat')

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
rng(1)
original_score = SVM(features, anList, goodsvm);
remove = [];
rng(1);
again = 1;
tracking = original_score;
original_score = original_score;
newsvm = goodsvm;
tracksvm = [];
tic
while sum(newsvm)
    tracksvm = [tracksvm, newsvm];
    again = 0;
    idx = find(newsvm==1);
    newsvm(idx(1)) = 0;
    first_score = SVM(features, anList, newsvm);
    diff1 = original_score - first_score;
    newsvm(idx(1)) = 1;
    bestIDX = 1;
    for i = 2:length(idx)
        newsvm(idx(i)) = 0;
        new_score = SVM(features, anList, newsvm);
        diff2 = original_score - new_score;
        if diff1 < diff2
            diff1 = diff2;
            bestIDX = i;
            bestScore = new_score;
        end
        newsvm(idx(i)) = 1;
    end
    newsvm(idx(bestIDX)) = 0;
    original_score = bestScore;
    disp(original_score)
    disp(sum(newsvm))
    tracking = [tracking, original_score];
end
toc
disp(original_score)
disp(sum(goodsvm))
    
% ~30 hours for full backward elimination
    