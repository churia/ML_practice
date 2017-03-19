function converge = PCAreduceDimension(inputfilename, threshold, savefilename)
% inputfilename is the file you want to process
% threshold si the value which if the enginvalue will be ingnored under the threshhold
% savefilename is the output file name

folderName = fullfile(pwd,inputfilename);
[label, feature] = libsvmread(folderName);
size(label)
size(feature)
temp = feature * feature';

% default setting we get eigenvalue at most number of 5000
[V, D, flag] = eigs(temp,5000);
gap = zeros(4900,1);
for i=2:1:5000
    gap(i-1,1) = D(i-1,i-1) - D(i,i);
end
last = 0;
ratio_threshold = threshold/1000;
disp(ratio_threshold);
for j = 1:1:4900;
    if(gap(j,1) < ratio_threshold)
        if(D(j,j) < threshold)
            last = j;
            disp(last);
            break;
        end
    end
end
if(j == 4900)
disp('Threshold is too low, default feature selection number is 3655');
last = 3655;
end
mapped_feature = V(:,1:last) * sqrt(D(1:last,1:last));
outputName = fullfile(pwd,savefilename);
s = sparse(mapped_feature);
libsvmwrite(outputName,label,s);
converge = flag;
end