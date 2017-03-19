%generate data
tic;
data=100*rand(100,2);
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
toc;