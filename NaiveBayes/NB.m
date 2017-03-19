function [predict]=NB(train_fea,train_gnd,test_fea,test_gnd)
%for continuous data 

Class_num = length(unique(train_gnd));
Para_mean =   cell(1,Class_num);%Mean for each feature and class
Para_dev = cell(1,Class_num);%Dev for each feature and class
Sample_byclass = cell(1,Class_num);%Reorder the data set by class
Prior_prob = zeros(1,Class_num);%Prior probability of each class
predict = zeros(size(test_gnd,1),1);

%Reorder the data set by class　and count prior 
for i=1:length(train_gnd) 
    Sample_byclass{1,train_gnd(i,1)} = [Sample_byclass{1,train_gnd(i,1)};train_fea(i,:)];
    Prior_prob(1,train_gnd(i,1)) = Prior_prob(1,train_gnd(i,1)) + 1;
end

% Prior probability，假设先验概率是样本频率
Prior_prob = Prior_prob/size(test_fea,1); 
tmepprob = log(Prior_prob);%求对数，用于后验概率的简化计算

posterior=zeros(size(test_fea,1),Class_num);

%training and fitting parameter,
%假设每个class分别服从高斯分布，根据训练样本分别计算每个class的均值和方差（标准差）
for i=1:1:Class_num 
     miu = mean(Sample_byclass{1,i});
     delta = std(Sample_byclass{1,i});   
     Para_mean{1,i} = miu;
     Para_dev{1,i} = delta;
end

%predict，对计算每个测试数据的后验概率，以此分类
for i=1:size(test_fea,1)   
     for j=1:Class_num%分别计算testdata在各个class中的概率
         
         %计算后验概率，根据naive bayes假设各个属性间是相互独立的。为方便计算，对概率求对数，(忽略含pi的常数项）。
         tmp=bsxfun(@plus, -0.5*(bsxfun(@rdivide,bsxfun(@minus,test_fea(i,:),Para_mean{1,j}(1,:)),Para_dev{1,j}(1,:))).^2,-log(Para_dev{1,j}(1,:)));  
         
         %处理无穷问题，忽略概率是无穷的属性
         posterior(i,j) = tmepprob(1,j)+nansum(tmp);
     end 
     [value index] = max(posterior(i,:));
     predict(i,1)=index;
end
