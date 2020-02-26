%%
%find categories in faceData.Labels
close all;clear all;
load('faceConvnet.mat');
faceDataLabels = categories(faceData.Labels);
row = size(faceDataLabels,1);
testAccuracy = zeros(row,1);

for i=1:row
    tempDataPath = strcat(faceDatasetPath,'/',faceDataLabels{i});
    tempDataStore = imageDatastore(tempDataPath);
    tempRow = size(tempDataStore.Files,1);
    testResult = classify(faceConvnet,tempDataStore);
    tempAccuracy = sum(testResult == faceDataLabels{i})/tempRow;
    testAccuracy(i) = tempAccuracy;
end
%create label set
labelSet = cell(row,1);
for i=1:row
    labelSet{i} = strcat('S',string(i));
end

figure;
barh((1:row),testAccuracy); ylim([0 40]);    
grid on;
xticks([0 0.5 1]);
xticklabels({'0%','50%','100%'});
yticks([1:1:40]);
yticklabels(labelSet);
ylabel('Face Label');xlabel('Classification Accuracy %');
title('Percentage Classification Accuracy');

