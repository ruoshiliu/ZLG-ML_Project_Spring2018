train = readtable('train_sample.csv','Format','%f %f %f %f %f %q %q %f');

yTrain = train(:,8);

yTrain = table2array(yTrain);

train(:,8) = [];

train(:,7) = [];

time = train(:,6);

time = table2array(time);

time = datenum(time);

train(:,6) = [];

 

train = table2array(train);

 

train = [train,time];

XTrain = train;
