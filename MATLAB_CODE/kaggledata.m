load kaggledata.mat
cv = cvpartition(size(XNew,1),'holdout',0.2);

%XNew - order of columns - ip - app - device - os - channel - year - month - day
% time of day is in a string array called time

%Splits the data into training and test sets
% XTrain = XNew(cv.training,:);
% yTrain = y(cv.training,1);
% XTest = XNew(cv.test,:);
% yTest = y(cv.test,1);

%XTrain = XNew(1:80000,:);
%yTrain = y(1:80000,1);
%XTest = XNew(80001:100000,:);
%yTest = y(80001:100000,1);


% standardize the data (substract mean and divide by standard deviation)
% Z - standardized data
[Z,mean,stdev] = zscore(XTrain);
XTrain = Z;
% standardizes the test set
XTest = XTest-mean;
for i = 1:size(XTest,2)
    XTest(:,i) = XTest(:,i)/stdev(1,i);
end

% SVM
%SVM = fitcsvm(Z,yTrain);
%yPTest = predict(SVM,XTest);

% Decision Tree
%DT = fitctree(XTrain,yTrain);
%[yPTest,score] = predict(DT,XTest);

% AdaBoosting
t = templateTree('MaxNumSplits',5);
Boost = fitcensemble(XTrain,yTrain,'Method','AdaBoostM1','NumLearningCycles',300,'Learners','Tree','scoreTransform','doublelogit');
[yPTest,score] = predict(Boost,XTest); %

% Bagging
% B = TreeBagger(50,XTrain,yTrain,'Method','Classification');
% [yPTest,score] = predict(B,XTest);
% yPTest =str2double(yPTest);

% error - returns accuracy and precision
[accuracy,precision,totalOnes,onesGuessed] = error2(yPTest,yTest);
