%%  data processing 

load kaggledata.mat
cv = cvpartition(size(XNew,1),'holdout',0.2);


%Splits the data into training and test sets
XTrain = XNew(cv.training,:);
yTrain = y(cv.training,1);
XTest = XNew(cv.test,:);
yTest = y(cv.test,1);

%% Using KNN with subspace learning 

t =  templateKNN('NumNeighbors',5,'Standardize',1);
Mdl= fitcensemble(XTrain,yTrain,'Method','subspace', "NLearn",'AllPredictorCombinations',"Learners", t); 
[yPTest,score] = predict(Mdl,XTest);
[accuracy,precision,totalOnes,onesGuessed] = error2(yPTest,yTest);
rsLoss = resubLoss(Mdl,'Mode','Cumulative');
plot(rsLoss);
xlabel('Number of Learning Cycles');
ylabel('Resubstitution Loss');
