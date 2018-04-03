load kaggledata.mat
cv = cvpartition(size(XNew,1),'holdout',0.2);

%XNew - order of columns - ip - app - device - os - channel - year - month - day
% time of day is in a string array called time

%Splits the data into training and test sets
XTrain = XNew(cv.training,:);
yTrain = y(cv.training,1);
XTest = XNew(cv.test,:);
yTest = y(cv.test,1);