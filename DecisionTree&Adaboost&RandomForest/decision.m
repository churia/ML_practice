function [result]=decision(data,index,g)
[n,d]=size(data);
t=length(g);
if t==3
    dsi=g{1}(1,1);
    dstheta=g{1}(1,2);
    l=zeros(n,1);
    r=zeros(n,1);
    left=index(find(data(index,dsi)<dstheta));
    right=index(find(data(index,dsi)>=dstheta));
    l(left)=1;
    r(right)=1;
    [leftresult]=decision(data,left,g{2});
    [rightresult]=decision(data,right,g{3});
    result=l.*leftresult+r.*rightresult;
else
    result=g;
end
