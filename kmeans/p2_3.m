%generate data
%pick 3 points as means
muA=100*rand(1,2);
muB=100*rand(1,2);
muC=100*rand(1,2);
%sigma=min{distanc(A,B),distance(A,C),distance(B,C)}/4;
Sigma=min([norm(muA-muB),norm(muA-muC),norm(muB-muC)])/4;
%generate each 50 points following normal distribution with mu and sigma
R = chol(Sigma);
data(1:50,:)=repmat(muA,50,1) + randn(50,2)*R;
data(51:100,:)=repmat(muB,50,1) + randn(50,2)*R;
data(101:150,:)=repmat(muC,50,1) + randn(50,2)*R;
%do kmeans with round=6 k=2 t=30;
r=6;k=2;t=30;
for i=1:r
    [clusters  centroids]=kmeans(data,k,t);
     %plot figures in one picture
    index1=(clusters==1);
    index2=(clusters==2);
    subplot(2,3,i);plot(data(index1,1),data(index1,2),'mo',data(index2,1),data(index2,2),'b+',centroids(:,1),centroids(:,2),'r*');
    title(['round ',num2str(i)])
end