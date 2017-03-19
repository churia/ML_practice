function [Ein,Eout,U,TOPX]=adaboost()
train=load('hw6_train.dat');
test=load('hw6_test.dat');
T=300;
[n,d]=size(train);
xtrain=train(:,1:d-1);
ytrain=train(:,d);
u=1/n*ones(n,1);
EinG=zeros(T,1);
EoutG=zeros(T,1);
U=zeros(T,1);
s=zeros(T,1);
it=zeros(T,1);
theta=zeros(T,1);
alpha=zeros(T,1);
for t=1:T
    U(t,1)=sum(u);%U(t)
    %g_t
    [s(t,1),it(t,1),theta(t,1),Ein_u_t,errIndex]=multi_decision_stump(train,u);
    epsilon=n*Ein_u_t/U(t,1);
    alpha(t,1)=log(sqrt((1-epsilon)/epsilon));
    %Ein(G)  
    Gtrain=zeros(n,1);
    for i=1:t
        xi=train(:,it(i,1));
        h=s(i,1)*sign(xi-theta(i,1));
        Gtrain=Gtrain+alpha(i,1)*h;
    end
    Ein(t,1)=length(find(sign(Gtrain)-ytrain))/n;
    %Eout(G)
    [ntest,d]=size(test);
    ytest=test(:,d);
    Gtest=zeros(ntest,1);
    for i=1:t
        xtest=test(:,it(i,1));
        h=s(i,1)*sign(xtest-theta(i,1));
        Gtest=Gtest+alpha(i,1)*h;
    end
    Eout(t,1)=length(find(sign(Gtest)-ytest))/ntest;
    %u(t+1)
    if t==300 
        break;
    end
    u=u*sqrt(epsilon/(1-epsilon));
    u(errIndex,1)=u(errIndex,1)*(1-epsilon)/epsilon;
end
tmpdata=[-u xtrain];
MaxUx=sortrows(tmpdata,1);
TOPX=MaxUx(1:10,2:d);
