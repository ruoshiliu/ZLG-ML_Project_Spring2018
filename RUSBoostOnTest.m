readData;
readTest;

% we will need to combine clickId with one column of the predictions in the
% future, so this is just changing it into an array of doubles called "clickId2"
clickId2 = table2array(clickId);

% standardize the data (substract mean and divide by standard deviation)
% Z - standardized data
[Z,mean,stdev] = zscore(XTrain);
XTrain = Z;
% standardizes the test set
test = test-mean;
test = test./stdev;

N = size(XTrain,1);
t = templateTree('MaxNumSplits',N);

% trains the model (MAKE SURE THERE IS NO SCORETRANSFORM)
rTree = fitcensemble(XTrain,yTrain,'Method','RUSBoost','NumLearningCycles',1000,'Learners',t,'NLearn',500,'LearnRate',0.01,'RatioToSmallest',[2,1]);

% predicts and gets the score
[yPTest,score] = predict(rTree,test);

% does softmax and gets the second column (% chance class is a 1)
soft_max = softmax2(score);
softSecondColumn = soft_max(:,2);

% combines clickId2 and softSecondColumn
pred = [clickId2 softSecondColumn];

% exports prediction to a csv file called 'predicitions.csv'
% writes the headers of the csv file
headers = {'click_id', 'is_attributed'};
csvwrite_with_headers('predictions.csv',pred,headers);

