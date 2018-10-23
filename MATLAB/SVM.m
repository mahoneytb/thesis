function score = SVM(data, labels, sequence)
rng(1);
idx = find(sequence==1);

x = data(idx, :);
x = x';
t = labels;

boxConstraints = 1000;
kernelScales = 37.500107370172260;
%% k fold version

% SVMModel = fitcsvm(x,t,'KernelFunction','rbf', 'KernelScale', kernelScales, ...
%      'BoxConstraint',boxConstraints,'ClassNames',{'T1','T2'},'Standardize',true);
% CVSVMModel = crossval(SVMModel, 'KFold', 3);
% score = kfoldLoss(CVSVMModel);

%% Holdout version
CVSVMModel = fitcsvm(x,t,'Holdout',0.15,'KernelFunction','rbf', 'KernelScale', kernelScales, ...
            'BoxConstraint',boxConstraints,'ClassNames',{'T1','T2'},'Standardize',true);
CompactSVMModel = CVSVMModel.Trained{1}; % Extract the trained, compact classifier
testInds = test(CVSVMModel.Partition);   % Extract the test indices
XTest = x(testInds,:);
YTest = t(testInds);
error = loss(CompactSVMModel,XTest,YTest);
score = error;
% score = error + sum(sequence)*0.005; %0.002 is good?

%% Parameter optimiser
% SVMModel = fitcsvm(x,t,'KernelFunction','rbf', 'KernelScale', 'auto', ...
%     'BoxConstraint',Inf,'ClassNames',{'T1','T2'});
% 
% CVSVMModel = crossval(SVMModel, 'KFold', 2);
% score = kfoldLoss(CVSVMModel);
% 
% sList = zeros(11);
% boxConstraints = [];
% ks = SVMModel.KernelParameters.Scale;
% kernelScales = [];
% for i = 1:11
%     boxConstraints = [boxConstraints 1*10^(i-6)];
%     kernelScales = [kernelScales ks*10^(i-6)];
% end
% 
% r = 1;
% c = 1;
% 
% for bc = boxConstraints
%     for kp = kernelScales %0.4580?
%         rng(1);
%         fprintf("r: %d, c: %d\n", kp, bc);
%         SVMModel = fitcsvm(x,t,'KernelFunction','rbf', 'KernelScale', kp, ...
%             'BoxConstraint',bc,'ClassNames',{'T1','T2'});
%         CVSVMModel = crossval(SVMModel, 'KFold', 2);
%         sList(r, c) = kfoldLoss(CVSVMModel);
%         if sList(r, c) < 0.4616
%             disp('here')
%         end
%         r = r+1;
%     end
%     r = 1;
%     c = c+1;
% end
% 
% score = sList;
% 
% [validationPredictions, validationScores] = kfoldPredict(CVSVMModel);
% C=confusionmat(t,validationPredictions); 
