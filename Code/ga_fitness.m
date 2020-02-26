function scores = ga_fitness(x,convLayers,trainFaceData,testFaceData,imgLength,imgWidth)

persistent genNumber;
if(isempty(genNumber))
    genNumber = 1;
end
scores = zeros(size(x,1),1);

for i=1:size(x,1)
    %defining the layers
    convConfig = x{i};
    genConvnetConfig(convLayers,convConfig(1:convLayers),convConfig(convLayers+1:2*convLayers),imgLength,imgWidth);
    run('tempScript.m');
    
    %specify the training options
    options = trainingOptions('sgdm','MaxEpochs',25,'MiniBatchSize',20,...
        'InitialLearnRate',0.001,'verbose',1);
        
    %train the network using training data
    faceConvnet = trainNetwork(trainFaceData,layers,options);
    
    YTest = classify(faceConvnet,testFaceData);
    TTest = testFaceData.Labels;
    
    %calculate accuracy
    accuracy = 100*sum(YTest == TTest)/numel(TTest);
    scores(i) = 100 - accuracy;
    
    dispString = strcat('======Generation : ',string(genNumber),'========Individual : ',string(i),'============');
    disp(dispString);
    dispAccuracy = strcat('Accuracy : ', string(accuracy));
    disp(dispAccuracy);
    filterNumbersString = strcat('Filter Numbers = ', string(convConfig(1:convLayers)));
    filterSizesString = strcat('Filter Sizes = ', string(convConfig(convLayers+1:2*convLayers)));
    disp(filterNumbersString);
    disp(filterSizesString);
    
end
save('initialPop.mat','scores','-append');
genNumber = genNumber + 1;
