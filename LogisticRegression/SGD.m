function w=SGD(train,eta,T)
%logistic regression with eta and update time T

[n,d]=size(train);
x=train(:,1:d-1);
x=[ones(n,1) x];
y=train(:,d);
%w=inv(x'*x)*x'*y;% use w_lin as w0 
w=zeros(d,1);

i=1;
for t=1:T
    if(i>n)
        i=1;
    end
    v=sigmoid(-y(i,1)*x(i,:)*w)*(-y(i,1)*x(i,:)); %pick one point each time
    w=w-eta*v';
    i=i+1;
end

function theta=sigmoid(s)
theta=1/(1+exp(-s));
