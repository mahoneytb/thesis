clear
load('finalAnnSet.mat')
load('finalFeatureSet.mat')
load('goodsvm8.mat')

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
while again
    again = 0;
    idx = find(goodsvm==1);
    for i = 1:length(idx)
        newsvm = goodsvm;
        newsvm(idx(i)) = 0;
        new_score = SVM(features, anList, newsvm);
        if (new_score < 0.24)
            goodsvm(idx(i)) = 0;
            remove = [remove, idx(i)];
            again = 1;
            original_score = new_score;
            disp(original_score)
            disp(sum(goodsvm))
            break;
        end
    end
end

disp(original_score)
disp(sum(goodsvm))
    
    