function [Ein,Eout,g,testResult]=p16(train,test)
[ntrain,d]=size(train);
[ntest,d]=size(test);
%Ein
[h,g]=decisionTree(train,linspace(1,ntrain,ntrain));
Ein=length(find(h-train(:,d)))/ntrain;
%Eout
testResult=decision(test,linspace(1,ntest,ntest),g);
Eout=length(find(testResult-test(:,d)))/ntest;
