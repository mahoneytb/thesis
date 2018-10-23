% Test the final solution

% Lets get down to bussiness, GA style
% Load the data
clear
load('finalAnnSet.mat')
load('finalFeatureSet.mat')
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

%% svm part
idx = find(goodsvm==1);

x = features(idx, :);
x = x';
t = anList;

boxConstraints = 1000;
kernelScales = 37.500107370172260;

%% Make model
CVSVMModel = fitcsvm(x,t,'KernelFunction','rbf', 'KernelScale', kernelScales, ...
            'BoxConstraint',boxConstraints,'ClassNames',{'T1','T2'},'Standardize',true);

%% Prep test data
load('test_anns.mat')
load('test_features.mat')

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

idx = find(goodsvm==1);

x = features(idx, :);
x = x';
t = anList;

error = loss(CVSVMModel,x,t);