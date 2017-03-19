function [gnd,idx,C,totsumD,l,exit]=kmeans(fea,gnd,sampleIdx,zeroIdx,k,iter)
%partition data "fea" to "k" clusters using Kmeans clustering method.
%return the cluster label "idx", total sum of sqare distance "totsumD",
%return "l" represent how many times the algorithm do iteration ,
%"exit"=0 means the function stops when "l" comes to "iter" which id given
%by user, "exit"=1 means the function stops when the current totsumD is
%larger than last iteration's,and return the result of the last iteration,
%"exit"=2 means the function stops when no points in the data set will
% move from one cluster to another.

%The problem of finding the global minimum sum of square distancescan can
%only be solved by doing several replicates with random starting points by
%user themselves, but since you have got the totol sum each time, you just 
%need to have several try and get the minimum sum of square distances.

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
% fea=fea(sampleIdx,:);
% gnd=gnd(sampleIdx,:);
% fea(:,zeroIdx)=[];

n=size(fea,1);

%initial centroids randomly
C = fea(randsample(n,k),:);

% Compute the distance from every point to each cluster centroid and the
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
    % Calculate the new cluster centroids and counts, and update the
    % distance from every point to those new cluster centroids
    [C(changed,:), m(changed)] = gcentroids(fea, idx, changed);
    D(:,changed)= dist(fea,C(changed,:));
    
    % Deal with clusters that have just lost all their members
    empties = changed(m(changed) == 0);
    for i = empties
        d = D((idx-1)*n + (1:n)');
        % Find the point furthest away from its current cluster.
        % Take that point out of its cluster and use it to create
        % a new singleton cluster to replace the empty one.
        [~, lonely] = max(d);
        from = idx(lonely); % taking from this cluster
        if m(from) < 2
            % In the very unusual event that the cluster had only
            % one member, pick any other non-singleton point.
            from = find(m>1,1,'first');
            lonely = find(idx==from,1,'first');
        end
        C(i,:) = fea(lonely,:);
        m(i) = 1;
        idx(lonely) = i;
        D(:,i) = dist(fea, C(i,:));
        % Update clusters from which points are taken
        [C(from,:), m(from)] = gcentroids(fea, idx, from);
        D(:,from) = dist(fea, C(from,:));
        changed = unique([changed from]);
    end
    
    % Compute the total sum of distances for the current configuration.
    totsumD = sum(D((idx-1)*n + (1:n)'));
    
    % Test for a cycle: if objective is not decreased, back out the last step 
    if prevtotsumD <= totsumD
        idx = previdx;
        [C(changed,:), m(changed)] = gcentroids(fea, idx, changed);
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
    % the other clusters'centroids will not change
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
% Compute the square euclidean distance from every point to each cluster centroid 
[n,p] = size(X);
D = zeros(n,size(C,1));%store distance from each point to each cluster centroid
for i = 1:size(C,1)
%   D(:,i)=sum((bsxfun(@minus,X,C(i,:))).^2,2);
    D(:,i) = (X(:,1) - C(i,1)).^2;
    for j = 2:p
        D(:,i) = D(:,i) + (X(:,j) - C(i,j)).^2;
    end    
end

function [centroids, counts] = gcentroids(X, index, clusts)
% Calculate each cluster's centroid and count
p = size(X,2);
k = length(clusts);
centroids = NaN(k,p);
counts = zeros(k,1);
for i = 1:k
    members = (index == clusts(i));
    counts(i) = sum(members);
    %assign the mean of the cluster as its centord
    centroids(i,:) = mean(X(members,:));
end