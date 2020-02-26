%%
%source of training faces: http://www.cl.cam.ac.uk/research/dtg/attarchive/facedatabase.html
%face recognition using convolutional neural network
clear all;close all;clc;

faceDatasetPath = 'C:\Work\02_Study\17_RobotVision_ECE588\Project\att_faces';
faceData = imageDatastore(faceDatasetPath,'IncludeSubfolders',true,'LabelSource','foldernames');    
%%
% view randomly selected images from source
dataSize = length(faceData.Files);
figure;
perm = randperm(dataSize,floor(dataSize*0.1));
for i = 1:4*floor(floor(dataSize*0.1)/5)
    subplot(4,floor(floor(dataSize*0.1)/5),i);
    imshow(faceData.Files{perm(i)});
end
%%
%check the number of images in each category
CountLabel = faceData.countEachLabel;
%%
%check the size of image
img = readimage(faceData,dataSize);
[length width] = size(img);
%%
%split data so that training data set has 750 files and rest of the files
%are in test data set
trainingNumFiles = 7;
rng(1) % For reproducibility
[trainFaceData,testFaceData] = splitEachLabel(faceData, ...
				trainingNumFiles,'randomize');
%%        
%defining the layers
%genConvnetConfig(4,[40 60 80 120],[12 8 6 4]);
genConvnetConfig(3,[74 27 23],[9 3 2],length,width);
run('tempScript.m');
%%
%specify the training options
options = trainingOptions('sgdm','MaxEpochs',25,'MiniBatchSize',20,...
	'InitialLearnRate',0.001,'verbose',1);
%%
%train the network using training data
faceConvnet = trainNetwork(trainFaceData,layers,options)
%%
YTest = classify(faceConvnet,testFaceData);
TTest = testFaceData.Labels;
%%
i = 29;
imshow(testFaceData.Files{i});
disp(testFaceData.Labels(i));
%%
%calculate accuracy
accuracy = sum(YTest == TTest)/numel(TTest);
disp(accuracy);
%%
save('faceConvnet.mat','faceConvnet','faceData','faceDatasetPath');