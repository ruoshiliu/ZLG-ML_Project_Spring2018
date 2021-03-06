%%  data processing 

load kaggledata.mat
cv = cvpartition(size(XNew,1),'holdout',0.2);


%Splits the data into training and test sets
XTrain = XNew(cv.training,:);
yTrain = y(cv.training,1);
XTest = XNew(cv.test,:);
yTest = y(cv.test,1);

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

%% using Robust Boosting 

t = templateTree('Surrogate','on','MaxNumSplits',5);
%mdl1 = fitcensemble(meas,species,'Method','Subspace','Learners',t1);
Mdl1 = fitcensemble(XTrain,yTrain,'Method','RobustBoost', "NLearn",500,"Learners", t); 
[yPTest,score] = predict(Mdl1,XTest);
[accuracy,precision,totalOnes,onesGuessed] = error2(yPTest,yTest);
rsLoss = resubLoss(Mdl1,'Mode','Cumulative');
plot(rsLoss);
xlabel('Number of Learning Cycles');
ylabel('Resubstitution Loss');
