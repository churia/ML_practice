function [left,right,BestI,BestTheta]=cut(data,index)
train=data(index,:);
[n,d]=size(train);
BestEin=1;%record the best of the best Ein
for i=1:d-1
    newtrain=[train(:,i),train(:,d)];
    sortrows(newtrain,1);%sort the data by x 
    x=newtrain(:,1);
    y=newtrain(:,2);
    Ein_best=1;%record the best Ein in i-dimension
    for j=1:n-1
        if x(j)~=x(j+1)
            theta=(x(j)+x(j+1))/2;%enumerate theta between two adjacent xs
            h=sign(x-theta);
            Ein_temp1=length(find(h-y))/n;%s=1
            Ein_temp2=length(find(-h-y))/n;%s=-1;
            %pick the min{Ein_best,Ein_temp1,Ein_temp2} as new bestEin
            %and record the corresponding s and theta
            %so break the tie by choosing the first Ein_best
            if Ein_temp1<Ein_temp2 && Ein_temp1<Ein_best
                Ein_best=Ein_temp1;
                s_best=1;
                theta_best=theta;
            end
            if Ein_temp2<Ein_temp1 && Ein_temp2<Ein_best
                Ein_best=Ein_temp2;
                s_best=-1;
                theta_best=theta;
            end
        end
    end
    %break the tie by simply choosing the first optimal
    if Ein_best<BestEin
        BestEin=Ein_best;
        BestI=i;
        BestTheta=theta_best;
    end
end
left=index(find(train(:,BestI)<BestTheta));
right=index(find(train(:,BestI)>=BestTheta));
