function avgEin=p13()
%return the average Ein of linear regression 
for n=1:1000
    x=1-2*rand(1000,2);
    %construct y with 10% noise. 
    r=sign(rand(1000,1)-0.1001);
    y=r.*sign(x(:,1).*x(:,1)+x(:,2).*x(:,2)-ones(1000,1)*0.6);
    x=[ones(1000,1) x];
    w=inv(x'*x)*x'*y;
    h=sign(x*w);
    e(n,1)=length(find(h-y))/1000;%0/1 error of linReg
end
avgEin=sum(e)/1000;