%%
%find categories in faceData.Labels
close all;clear all;
load('faceConvnet.mat');
faceDataLabels = categories(faceData.Labels);
[row,col] = size(faceDataLabels);
testAccuracy = zeros(row,1);
figure;
for(i=1:1:row)
    tempDataPath = strcat(faceDatasetPath,'/',faceDataLabels{i});
    tempDataStore = imageDatastore(tempDataPath);
    [tempRow,tempCol] = size(tempDataStore.Files);
    testResult = classify(faceConvnet,tempDataStore);
    tempAccuracy = sum(testResult == faceDataLabels{i})*100/tempRow;
    testAccuracy(i) = tempAccuracy;
    subplot(16,5,i);
    imshow(tempDataStore.Files{1});
end
figure;
bar(testAccuracy); ylim([0 120]);    