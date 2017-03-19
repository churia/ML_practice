function Eout=p15()
% return Etest of linear regression
for i=1:1000
    x=1-2*rand(1000,2);
    r=sign(rand(1000,1)-0.1001);
    y=r.*sign(x(:,1).*x(:,1)+x(:,2).*x(:,2)-ones(1000,1)*0.6);
    z=[ones(1000,1) x x(:,1).*x(:,2) x(:,1).*x(:,1) x(:,2).*x(:,2) ];
    w=inv(z'*z)*z'*y;
    %construct test data
    x=1-2*rand(1000,2);
    r=sign(rand(1000,1)-0.1001);
    y=r.*sign(x(:,1).*x(:,1)+x(:,2).*x(:,2)-ones(1000,1)*0.6);
    z=[ones(1000,1) x x(:,1).*x(:,2) x(:,1).*x(:,1) x(:,2).*x(:,2) ];
    h=sign(z*w);
    e(i,1)=length(find(h-y))/1000;% Eout
end
Eout=sum(e)/1000;