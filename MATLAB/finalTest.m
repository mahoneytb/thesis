% Test the final solution

% Lets get down to bussiness, GA style
% Load the data
clear
load('test_anns.mat')
load('test_features.mat')
load('goodsvm9.mat')
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

s = SVM(features, anList, goodsvm);