M = readtable('train_sample.csv');
l = M(:,8);
l = table2array(l);
M(:,8) = [];
date = M(:,6);
date_num = datenum(table2array(date));
M(:,6) = [];
M = addvars(M,date_num,'Before','attributed_time');
att_t = M.attributed_time;
M(:,7) = [];
M = table2array(M);
% [M,MU,SIGMA] = zscore(M);
% [w,t,fp]=fisher_training(M,l);
num_train = size(M,1)*0.8;
M_train = M(1:num_train,:);
M_test = M(num_train+1:size(M,1),:);
l_train = l(1:num_train,1);
l_test = l(num_train+1:size(M,1),1);

ens = generic_random_forests(M_train,l_train,50,'classification');
[Yfit,scores] = predict(ens,M_test);

result = zeros(length(Yfit),1);
Yfit_mat = cell2mat(Yfit);
for j = 1:length(Yfit)
    if isequal(Yfit_mat(j,1),'0')
        result(j,1) = 0;
    else
        result(j,1) = 1;
    end
end

tp= sum( (result==1) & (l_test==1) );
fn= sum( (result==1) & (l_test==0) );
fp= sum( (result==0) & (l_test==1) );
tn= sum( (result==0) & (l_test==0) );

precision=tp/(tp+fp)
recall=tp/(tp+fn);
accuracy=(tp+tn)/(tp+tn+fp+fn)
F1=2*precision*recall/(precision+recall);





