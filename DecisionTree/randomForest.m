function Eout=randomForest(T)
train=load('hw6_train.dat');
test=load('hw6_test.dat');
[n,d]=size(train);
[ntest,d]=size(test);
Gtest=zeros(ntest,1);
Gin=zeros(n,1);
for t=1:T
    sampleIdx=ceil(n*rand(1,n));
    bagTrain=train(sampleIdx,:);
    [Ein,Eout,g,result]=p16(bagTrain,test);
    Gtest=Gtest+result;
    Gin=Gin+g;
    Eint(t,1)=length(find(sign(Gin)-train(:,d)))/n;
    Eoutt(t,1)=length(find(sign(Gtest)-test(:,d)))/ntest;
end

%hist(Eout);
Tx=linspace(1,T,T);
plot(Tx,Eint,Tx,Eoutt);
legend('Ein(Gt)','Eout(Gt)');