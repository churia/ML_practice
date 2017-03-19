function Etest=muti_test(test,s,i,theta)
%problem 20
%input test data, optimal s,i,theta
%return Etest

[n,d]=size(test);
x=test(:,i);
y=test(:,d);
h=s*sign(x-theta);
Etest=length(find(h-y))/n;