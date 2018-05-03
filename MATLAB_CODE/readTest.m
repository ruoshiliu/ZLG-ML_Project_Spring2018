test = readtable('test-2.csv','Format','%f %f %f %f %f %f %q');

 

clickId = test(:,1);

 

time = test(:,7);

time = table2array(time);

time = datenum(time);

test(:,7) = [];

 

test = table2array(test);

test(:,1) = [];

 

test = [test,time];
