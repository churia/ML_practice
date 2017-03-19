function [BestS,BestI,BestTheta,BestEin_u,ErrIndex]=multi_decision_stump(train,utrain)
%train is the training data
%return best s,i,theta
[n,d]=size(train);
BestEin_u=1;%record the best of the best Ein
for i=1:d-1
    newtrain=[train(:,i),train(:,d),utrain];
    sortrows(newtrain,1);%sort the data by x 
    x=newtrain(:,1);
    y=newtrain(:,2);
    u=newtrain(:,3);
    Ein_best=1;%record the best Ein in i-dimension
    %consider theta at the left most and right most(i.e. all ys has same label) 
    bound_theta=[x(1)-1,x(n)+1];
    t=1;
    for j=1:n-1
        if(t<=2)%enumerate 2 special cases
            theta=bound_theta(t);
            t=t+1;
        else
            theta=(x(j)+x(j+1))/2;%enumerate theta between two adjacent xs
        end
        h=sign(x-theta);
        Ein_temp1=sum(u(find(h-y)))/n;%s=1
        Ein_temp2=sum(u(find(-h-y)))/n;%s=-1;
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
    %break the tie by simply choosing the first optimal
    if Ein_best<BestEin_u
        BestEin_u=Ein_best;
        BestI=i;
        BestS=s_best;
        BestTheta=theta_best;
    end
end

g_Best=BestS*sign(train(:,BestI)-BestTheta);
ErrIndex=find(g_Best-train(:,d));
