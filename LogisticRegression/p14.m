function E=p14()
% return the list of four options' Ein
% and choose the smallest one as the correct answer

w=[-1 -0.05 0.08 0.13 1.5 1.5;
        -1 -0.05 0.08 0.13 1.5 15;
        -1 -0.05 0.08 0.13 15 1.5;
        -1 -1.5 0.08 0.13 0.05 0.05];
for t=1:4
    for i=1:1000
        x=1-2*rand(1000,2);
        %construct y with 10% noise. 
        r=sign(rand(1000,1)-0.1001);
        y=r.*sign(x(:,1).*x(:,1)+x(:,2).*x(:,2)-ones(1000,1)*0.6);
        %transform x to z
        z=[ones(1000,1) x x(:,1).*x(:,2) x(:,1).*x(:,1) x(:,2).*x(:,2) ];
        h=sign(z*w(t,:)');
        e(i,1)=length(find(h-y))/1000;
    end
    E(t,1)=sum(e)/1000;
end