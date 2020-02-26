%%
%source of training faces: http://www.cl.cam.ac.uk/research/dtg/attarchive/facedatabase.html
%face recognition using convolutional neural network
clear all;close all;clc;

faceDatasetPath = 'C:\Work\02_Study\17_RobotVision_ECE588\FinalProject\att_faces';
faceData = imageDatastore(faceDatasetPath,'IncludeSubfolders',true,'LabelSource','foldernames'); 
pause_flag = 0;

numLabels = size(categories(faceData.Labels),1);

%create label set
labelSet = cell(numLabels,1);
for i=1:numLabels
    labelSet{i} = strcat('S',string(i));
end

load('faceConvnet.mat');
figure;
for i=1:numLabels
    tempDataPath = strcat(faceDatasetPath,'\','s',string(i));
    tempDataStore = imageDatastore(char(tempDataPath));
    testResult = classify(faceConvnet,tempDataStore);
    numResults = size(testResult,1);
    labelCount = zeros(numLabels,1);
    for j=1:numResults
        for k=1:numLabels
            labelCount(k) = labelCount(k) + (testResult(j) == strcat('s',string(k)));
        end
    end
    actualLabel = strcat('s',string(i));
    subplot(1,2,1);
    plotImageResults(tempDataStore,testResult,actualLabel);
    subplot(1,2,2);
    bar((1:1:40),labelCount*100/sum(labelCount),'r');hold on;
    xlim([0 42]);ylim([0 105]);
    bar(i,labelCount(i)*100/sum(labelCount),'g');hold off; 
    xticks([1:1:40]);
    xtickangle(90);
    xticklabels(labelSet);
    ylabel('Face Label');xlabel('Classification Accuracy %');    
    title(strcat({'Actual Label: '},{string(actualLabel)}));
    xlabel('Label Number');ylabel('Percentage Accuracy');
    if(pause_flag == 0)
        pause;
        pause_flag = 1;
    end
    pause(0.1);
    
end           
            
    