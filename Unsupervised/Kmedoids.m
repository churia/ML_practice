function [gnd,idx,totsumD,l,exit]=Kmedoids(fea,gnd,sampleIdx,zeroIdx,k,iter)
%same phase as the Kmeans,just different in function "getmodoids":
%Kmedois chooses data point in the cluster which has least square of distance 
%to the other data as centers

%input: fea: feature set of the orignal data 
%       gnd: target class label set of the orignal data
%       sampleIdx: parameter of sample selection
%       zeroIdx: parameter of sample selection
%       k; the number of the target clusters
%       iter: the largest number of iterations that the function should do
% output: gnd: the target class label set after sample selection
%         idx: the class label given by the clustering algorithm
%         totsumD: total sum of the square distance
%         l: the specific number of the iteration
%         exit: the way the function exit from the iteration


%   sample selection 
fea=fea(sampleIdx,:);
gnd=gnd(sampleIdx,:);
fea(:,zeroIdx)=[];

n=size(fea,1);

%initial medoids randomly
C = fea(randsample(n,k),:);

% Compute the distance from every point to each cluster medoid and the
% initial assignment of points to clusters
D = dist(fea,C);
[d, idx] = min(D, [], 2);

m = accumarray(idx,1,[k,1]);
previdx = idx;
prevtotsumD = sum(D((idx-1)*n + (1:n)'));
changed=1:k;
l=0;
exit=0;

while true
    if l>=iter
        break;
    end
    % Calculate the new cluster medoids and counts, and update the
    % distance from every point to those new cluster medoids
    [C(changed,:), m(changed)] = getmedoids(fea, idx, changed);
    D(:,changed)= dist(fea,C(changed,:));
    
    % Compute the total sum of distances for the current configuration.
    totsumD = sum(D((idx-1)*n + (1:n)'));
    
    % Test for a cycle: if objective is not decreased, back out the last step 
    if prevtotsumD <= totsumD
        idx = previdx;
        [C(changed,:), m(changed)] = getmedoids(fea, idx, changed);
        exit=1;
        break;
    end
    
    %else continue the loop
    previdx = idx;
    prevtotsumD = totsumD;
    [d, nidx] = min(D, [], 2);
    
    % Determine which points moved
    moved = find(nidx ~= previdx);
    if ~isempty(moved)
        % find the points which should be moved
        moved = moved(D((previdx(moved)-1)*n + moved) > d(moved));
    end
    
    %end when no point should be moved
    if isempty(moved)
        exit=2;
        break;
    end
    
    %reassign the new cluster
    idx(moved) = nidx(moved);
            
    % Find clusters that gained or lost members
    % the other clusters'medoids will not change
    changed = unique([idx(moved); previdx(moved)])';
    
    l=l+1;
end

% Calculate cluster-wise sums of distances
nonempties = find(m>0);
D(:,nonempties) = dist(fea, C(nonempties,:));
d = D((idx-1)*n + (1:n)');
sumD = accumarray(idx,d,[k,1]);
totsumD = sum(sumD);
        
function D=dist(X,C)
% Compute the square euclidean distance from every point to each cluster medoid 
[n,p] = size(X);
D = zeros(n,size(C,1));%store distance from each point to each cluster medoid
for i = 1:size(C,1)
    D(:,i) = (X(:,1) - C(i,1)).^2;
    for j = 2:p
        D(:,i) = D(:,i) + (X(:,j) - C(i,j)).^2;
    end    
end

function [medoid, counts] = getmedoids(X, index, clusts)
% Calculate each cluster's medoid and count
p = size(X,2);
k = length(clusts);
medoid = NaN(k,p);
counts = zeros(k,1);
for i = 1:k
    members = (index == clusts(i));
    counts(i) = sum(members);
    cluster=X(members,:);
    tempDist=zeros(counts(i),1);
    for j=1:size(cluster,1)
        tempDist(j,:)=sum(sum((bsxfun(@minus,cluster,cluster(j,:))).^2,2));
    end
    [v,ind]=min(tempDist);
     %assign the point in the cluster which has least square of distance to 
     %the other data as its medoid
    medoid(i,:)=cluster(ind,:);    
end