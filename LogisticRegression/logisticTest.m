function Eout=logisticTest(test,w)
[n,d]=size(test);
x=test(:,1:d-1);
x=[ones(n,1) x];
y=test(:,d);
h=sign(x*w);
Eout=length(find(h-y))/n;