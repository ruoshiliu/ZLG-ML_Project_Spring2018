load kaggledata.mat
cv = cvpartition(size(XNew,1),'holdout',0.2);

%XNew - order of columns - ip - app - device - os - channel - datenum
% time of day is in a string array called time

%Splits the data into training and test sets
XTrain = XNew(cv.training,:);
yTrain = y(cv.training,1);
XTest = XNew(cv.test,:);
yTest = y(cv.test,1);

% standardize the data (substract mean and divide by standard deviation)
% Z - standardized data
[Z,mean,stdev] = zscore(XTrain);
XTrain = Z;
% standardizes the test set
XTest = XTest-mean;
XTest = XTest./stdev;

N = size(XTrain,1);
t = templateTree('MaxNumSplits',N);

rTree = fitcensemble(XTrain,yTrain,'Method','RUSBoost','NumLearningCycles',1000,'Learners',t,'NLearn',500,'LearnRate',0.01,'RatioToSmallest',[2,1],'ScoreTransform','logit');
[yPTest,score] = predict(rTree,XTest);

[accuracy,precision,totalOnes,onesGuessed] = error2(yPTest,yTest);
% plotting the resubstitution error for each learning cycles (cumulative)
rsLoss = resubLoss(Mdl1,'Mode','Cumulative');
plot(rsLoss);
xlabel('Number of Learning Cycles');
ylabel('Resubstitution Loss');
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
