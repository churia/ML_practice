function [predict,posterior]=DNB(train_fea,train_gnd,test_fea,test_gnd,smooth)
%for discrete data

Class_num = length(unique(train_gnd));
Sample_byclass = cell(1,Class_num); 
Prior_prob = zeros(1,Class_num);
predict = zeros(size(test_gnd,1),1);

%Reorder the data set by class��and count prior 
for i=1:length(train_gnd) 
    Sample_byclass{1,train_gnd(i,1)} = [Sample_byclass{1,train_gnd(i,1)};train_fea(i,:)];
    Prior_prob(1,train_gnd(i,1)) = Prior_prob(1,train_gnd(i,1)) + 1;
end

% Prior probability�������������������Ƶ��
Prior_freq = Prior_prob;
Prior_prob = Prior_prob/size(test_fea,1); 
tmepprob = log(Prior_prob);%����������ں�����ʵļ򻯼���

posterior=zeros(size(test_fea,1),Class_num);
if (smooth==0)
    smo=0;
else
    smo=1;
end
%predict���Լ���ÿ���������ݵĺ�����ʣ��Դ˷���
for i=1:size(test_fea,1) 
     for j=1:Class_num%�ֱ����testdata�ڸ���class�еĸ���
         tmp=0;
         for k=1:size(test_fea,2)
             %smoothing
             count=length(find(Sample_byclass{1,j}(:,k)==test_fea(i,k)))+smo;
             tmp=tmp+log(count/(Prior_freq(1,j)+smooth));
         end
         posterior(i,j) = tmepprob(1,j)+tmp;
     end 
     [value index] = max(posterior(i,:));
     predict(i,1)=index;
end
