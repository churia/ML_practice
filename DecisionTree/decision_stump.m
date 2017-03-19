function [avgEin,avgEout]=decision_stump(n,iteration)
% problem 17
% n is the size of x
% iteration=5000
% return average Ein, Eout

sumEin=0;sumEout=0;
for iter=1:iteration

    x=sort(1-2*rand(n,1));%generate x by a uniform distribution in [-1,1]

    %generate 20% probability noisy sign. Note that 0.2001 is to make sure the 
    %random number smaller than 0.2 or equal to 0.2 will generate noise.
    r=sign(rand(n,1)-0.2001);

    y=r.*sign(x);%generate y=sign(x) with 20% noise
    
    Ein_best=1;%initialize the best Ein
    %consider theta at the left most and right most(i.e. all ys has same label) 
    bound_theta=[x(1,1)-1,x(n,1)+1];
    t=1;
    %enumerate all the possible s and theta
    for i=1:n-1
        for j=i+1:n
            if(t<=2)%enumerate 2 special cases
                theta=bound_theta(1,t);
                t=t+1;
            else
                theta=(x(i)+x(j))/2;%enumerate theta between any two of xs
            end
            h=sign(x-theta);
            Ein_temp1=length(find(h-y))/n;%s=1
            Ein_temp2=length(find(-h-y))/n;%s=-1;
            %pick the min{Ein_best,Ein_temp1,Ein_temp2} as new bestEin
            %and record the corresponding s and theta
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
    %according the algorithm above, break the tie by simply choosing the
    %first met optimal
    sumEin=sumEin+Ein_best;%calculate sum of Ein
    %calculate Eout
    if s_best==1
        Eout=0.2+0.3*abs(theta_best)/2;
    end
    if s_best==-1
        Eout=0.8-0.3*abs(theta_best)/2;
    end
    sumEout=sumEout+Eout;
end
avgEin=sumEin/iter;
avgEout=sumEout/iter;