function target=Knn(train_data,test_data,k)

load(test_data);%�����������
test_fea=fea;%�����������
load(train_data);%����ѵ������
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
    %�������������ѵ�����ݵľ��룬������ŷʽ����
    for i=1:fea_m
        dist(i)=norm(train_fea(i,:)-test_fea(j,:));
    end
    [~,index]=sort(dist);
    %�������ǰk�����ڵ����
    for i=1:k
        ind=find(ClassLabel==train_gnd(index(i)));
        cnt(ind)=cnt(ind)+1;
    end
    [tmp,ind]=max(cnt);
    target(j,1)=ClassLabel(ind);
end