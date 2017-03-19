function [base,node]=decisionTree(data,index)
[n,d]=size(data);
t=length(index);
if t==1 %datasize==1
    base=data(index,d);
    node=base;
elseif abs(sum(data(index,d)))==t % all ys are same
    yidx=zeros(n,1);
    yidx(index)=1;
    node=data(index(t),d);
    base=yidx.*node;
else  
    x=data(index,1:d-1);
    flag=0;
    for i=1:d-1
        meanxi=mean(x(:,i));
        meanX=meanxi*ones(t,1);
        if meanX~=x(:,i)
            flag=1;
            break;
        end
    end
    if flag==0 % all xs are same
        node=sign(sum(data(index,d)));
        xidx=zeros(n,1);
        xidx(index)=1;
        if node==0 %if two xs has different y set all +1
            node=1;
        end
        base=xidx.*node;
    else
        [left,right,besti,theta]=cut(data,index);
        l=zeros(n,1);
        r=zeros(n,1);
        l(left)=l(left)+1;
        r(right)=r(right)+1;
        [leftbase,leftnode]=decisionTree(data,left);
        [rightbase,rightnode]=decisionTree(data,right);
        base=l.*leftbase+r.*rightbase;
        node=cell(1,3);
        node{1,1}=[besti,theta];
        node{1,2}=leftnode;
        node{1,3}=rightnode;
    end
end
