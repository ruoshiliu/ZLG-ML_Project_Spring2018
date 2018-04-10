load kaggledata.mat
cv = cvpartition(size(XNew,1),'holdout',0.2);

%XNew - order of columns - ip - app - device - os - channel - datenum
% time of day is in a string array called time

%% Splits the data into training and test sets
XTrain = XNew(cv.training,:);
yTrain = y(cv.training,1);
XTest = XNew(cv.test,:);
yTest = y(cv.test,1);

%% standardize the data (substract mean and divide by standard deviation)
% Z - standardized data
[Z,mean,stdev] = zscore(XTrain);
XTrain = Z;
% standardizes the test set
XTest = XTest-mean;
XTest = XTest./stdev;

N = size(XTrain,1);
t = templateTree('MaxNumSplits',N);

%% parameters
num_Cycles = 2000;
num_Learners = 500;
LearnRate = 0.1;
ratioToSmallest = 2;

%% train and predict
rTree = fitcensemble(XTrain,yTrain,'Method','RUSBoost','NumLearningCycles',num_Cycles,'Learners',t,'NLearn',num_Learners,'LearnRate',LearnRate,'RatioToSmallest',[ratioToSmallest,1],'ScoreTransform','logit');
[yPTest,score] = predict(rTree,XTest);

%% results
[accuracy,precision,totalOnes,onesGuessed] = error2(yPTest,yTest);
ratio_GuessCorrect = onesGuessed / totalOnes;
ones_correct = totalOnes*precision*0.01 / onesGuessed;
results = ["num_Cycles",num_Cycles;"num_Learners",num_Learners;"LearnRate",LearnRate;"ratioToSmallest",ratioToSmallest;" "," ";"accuracy",accuracy*0.01; "precision",precision*0.01; "ratio_GuessCorrect",ratio_GuessCorrect; "ones_correct",ones_correct];

%%
% figure;
% tic
% plot(loss(rTree,XTest,yTest,'mode','cumulative'));
% toc
% grid on;
% xlabel('Number of trees');
% ylabel('Test classification error');

% tic
% Yfit = predict(rTree,XTest);
% toc
% tab = tabulate(yTest);
% bsxfun(@rdivide,confusionmat(yTest,Yfit),tab(:,2))*100