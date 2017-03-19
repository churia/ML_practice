function [predict]=NB(train_fea,train_gnd,test_fea,test_gnd)
%for continuous data 

Class_num = length(unique(train_gnd));
Para_mean =   cell(1,Class_num);%Mean for each feature and class
Para_dev = cell(1,Class_num);%Dev for each feature and class
Sample_byclass = cell(1,Class_num);%Reorder the data set by class
Prior_prob = zeros(1,Class_num);%Prior probability of each class
predict = zeros(size(test_gnd,1),1);

%Reorder the data set by class��and count prior 
for i=1:length(train_gnd) 
    Sample_byclass{1,train_gnd(i,1)} = [Sample_byclass{1,train_gnd(i,1)};train_fea(i,:)];
    Prior_prob(1,train_gnd(i,1)) = Prior_prob(1,train_gnd(i,1)) + 1;
end

% Prior probability�������������������Ƶ��
Prior_prob = Prior_prob/size(test_fea,1); 
tmepprob = log(Prior_prob);%����������ں�����ʵļ򻯼���

posterior=zeros(size(test_fea,1),Class_num);

%training and fitting parameter,
%����ÿ��class�ֱ���Ӹ�˹�ֲ�������ѵ�������ֱ����ÿ��class�ľ�ֵ�ͷ����׼�
for i=1:1:Class_num 
     miu = mean(Sample_byclass{1,i});
     delta = std(Sample_byclass{1,i});   
     Para_mean{1,i} = miu;
     Para_dev{1,i} = delta;
end

%predict���Լ���ÿ���������ݵĺ�����ʣ��Դ˷���
for i=1:size(test_fea,1)   
     for j=1:Class_num%�ֱ����testdata�ڸ���class�еĸ���
         
         %���������ʣ�����naive bayes����������Լ����໥�����ġ�Ϊ������㣬�Ը����������(���Ժ�pi�ĳ������
         tmp=bsxfun(@plus, -0.5*(bsxfun(@rdivide,bsxfun(@minus,test_fea(i,:),Para_mean{1,j}(1,:)),Para_dev{1,j}(1,:))).^2,-log(Para_dev{1,j}(1,:)));  
         
         %�����������⣬���Ը��������������
         posterior(i,j) = tmepprob(1,j)+nansum(tmp);
     end 
     [value index] = max(posterior(i,:));
     predict(i,1)=index;
end
