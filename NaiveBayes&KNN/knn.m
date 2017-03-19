function target=Knn(train_data,test_data,k)

load(test_data);%载入测试数据
test_fea=fea;%定义测试样本
load(train_data);%载入训练数据
train_fea=fea;
train_gnd=gnd;

ClassLabel=unique(train_gnd);
gnd_n=length(ClassLabel);
fea_m=size(train_fea,1);
t_n=size(test_fea,1);
target=zeros(size(test_data,1),1);
dist=zeros(fea_m,1);

for j=1:t_n
    cnt=zeros(gnd_n,1);
    %计算测试数据与训练数据的距离，这里是欧式距离
    for i=1:fea_m
        dist(i)=norm(train_fea(i,:)-test_fea(j,:));
    end
    [~,index]=sort(dist);
    %计算最近前k个近邻的类别
    for i=1:k
        ind=find(ClassLabel==train_gnd(index(i)));
        cnt(ind)=cnt(ind)+1;
    end
    [tmp,ind]=max(cnt);
    target(j,1)=ClassLabel(ind);
end