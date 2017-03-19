function [clusters old_C]=kmeans(X,k,T)
[n,d]=size(X);
clusters=zeros(n,1);
%initialize k centroids randomly
init_C=X(randsample(n,k),:);
old_C=init_C;%centroids after t-1 iterations
cur_C=zeros(k,d);%current centroids after t iterations
t=0;
while true 
    %stop after T iteratations
    if t >= T
        break;
    end
    %Compute euclidean distance between every point to each cluster centroid
    for i=1:n
        mindist=[Inf,0];
        for j=1:k
            distance = norm(X(i,:)-old_C(j,:));
            if distance < mindist(1,1)
                mindist(1,1)=distance;
                mindist(1,2)=j;
            end
        end
        clusters(i,1)=mindist(1,2);
    end
    % Calculate each cluster's centroid
    for j=1:k
        index = (clusters==j);
        cur_C(j,:) = mean(X(index,:));
    end
    % sotp when converge
    if ~isequal(old_C,cur_C) 
        old_C=cur_C;
    else
        break;
    end
    t=t+1;
end

