function w=logisticRegresion(train,eta,T)
%logistic regression with eta and update time T

[n,d]=size(train);
x=train(:,1:d-1);
x=[ones(n,1) x];
y=train(:,d);
%w=inv(x'*x)*x'*y; % use w_lin as w0 
w=zeros(d,1);

for t=1:T
    w=w-eta*grad(x,y,w,n)';
end

% compute gradient Ein
function gradE=grad(x,y,w,n)
for i=1:n
    theta=sigmoid(-y(i,1)*x(i,:)*w);
    e(i,:)=theta*(-y(i,1)*x(i,:));
end
gradE=sum(e)/n;

% compute sigmoid function
function theta=sigmoid(s)
theta=1/(1+exp(-s));



