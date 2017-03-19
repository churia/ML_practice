function [gnd,idx,l,Px]=GMM(fea,gnd,sampleIdx,zeroIdx,d,k)
%clustering by GMM with EM algorithm
%also initialize the pamareter by kmeans
%do Dimension Reduction with PCA algorithm
%input: fea: feature set of the orignal data 
%       gnd: target class label set of the orignal data
%       sampleIdx: parameter of sample selection
%       zeroIdx: parameter of sample selection
%       k; the number of the target clusters
%       d: the number of feature dimenstion after reduction
%output:  gnd: the target class label set after sample selection
%         idx: the class label given by the clustering algorithm
%         l: the specific number of the iteration
%         Px:the posteriors of each sample in k clusters

fea=fea(sampleIdx,:);
gnd=gnd(sampleIdx,:);
fea(:,zeroIdx)=[];

%Dimension Reduction by PCA
fea=PCA(fea,d);
n=size(fea,1);

[g,dx,C]=kmeans(fea,gnd,sampleIdx,zeroIdx,k,100);
%初始化参数
Mu = C;
Sigma = cell(k,1);
Alpha = zeros(k,1);
for i=1:k
    Sigma{i,1} = cov(bsxfun(@minus,fea,Mu(i,:)));
    Alpha(i,1) = 1/k; 
end
% EM 迭代停止条件: |loglike-loglike_old|<loglike_threshold
loglike_threshold = 1e-10; 
loglike_old=-Inf;

l=0;
while(true)
    
    l=l+1;
    Px=zeros(n,k);
    Beta_i=zeros(n,k);
    Beta=zeros(k,1);
    
    %E-step
    for i=1:k  
    %calculate the Guassaion Probability Density Function for the samples
        Px(:,i) = GaussPDF(fea, Mu(i,:), Sigma{i,1});
        if length(find(Px(:,i)==0))==n
            Px(:,i)=ones(n,1)*1e-10;
        end
    end  
    for i=1:k 
        Beta_i(:,i)=Alpha(i,:).*Px(:,i);
    end
    sumBeta=sum(Beta_i,2);
    for i=1:k 
        Beta_i(:,i)=Beta_i(:,i)./sumBeta;
    end
    % Stopping criterion 
    loglike = sum(log(sumBeta));  
    % Stop the process depending on the increase of the log likelihood  
    if abs(loglike-loglike_old) < loglike_threshold  
        break;  
    end  
    loglike_old = loglike; 
    
    %M-step
    for i=1:k  
        Beta(i,:)=sum(Beta_i(:,i));
        % 更新权值  
        Alpha(i,:) = Beta(i,:) / n;  
        % 更新均值  
        Mu(i,:) = sum(bsxfun(@times,fea,Beta_i(:,i)))./ Beta(i,:);  
        % 更新方差  
        sigma=0;
        for j=1:n
            tmp=fea(j,:)-Mu(i,:);
            sigma=sigma+tmp'*tmp*Beta_i(j,i);
        end
        Sigma{i,1} = sigma./ Beta(i,:); 
        % Add a tiny variance to avoid numerical instability 
        [h,q]=size(Sigma{i,1});
        Sigma{i,1} = Sigma{i,1} + 1E-10*ones(d,d); 
    end
  
end
[v,idx]=max(Px,[],2);

function [V]=PCA(fea,d)
%Dimension Reduction by PCA
miu=mean(fea);
tmp=bsxfun(@minus,fea,miu);
S=cov(tmp);
[V,D]=eigs(S,d);%get d largest eigenvectors
V=fea*V;

function Prob = GaussPDF(Data, Mu, Sigma)  
%calculate the Guassaion Probability Density Function for the samples    
dim = size(Data,1);  
Data = bsxfun(@minus,Data,Mu); 
prob = sum((Data*pinv(Sigma)).*Data, 2);  
deta=abs(det(Sigma));
if deta==inf 
    deta=realmin;
end
Prob = exp(-0.5*prob) ./ sqrt((2*pi)^dim * deta);  
%Prob = -0.5*prob - dim/2*log(2*pi)-0.5*log (deta);  





