%%
clear all;close all;clc;
faceDatasetPath = 'C:\Work\02_Study\17_RobotVision_ECE588\Project\att_faces';
faceData = imageDatastore(faceDatasetPath,'IncludeSubfolders',true,'LabelSource','foldernames');    

% view randomly selected images from source
dataSize = size(faceData.Files,1);

%check the number of images in each category
CountLabel = faceData.countEachLabel;

%check the size of image
img = readimage(faceData,dataSize);
[imgLength,imgWidth] = size(img);

%split data so that training data set has 750 files and rest of the files
%are in test data set
trainingNumFiles = 7;
rng(1) % For reproducibility
[trainFaceData,testFaceData] = splitEachLabel(faceData,trainingNumFiles,'randomize');

%% parameters for convolutional neural network

convLayers = 3;
convParams = 2*convLayers;

maxNumFilters = 100;
maxFilterSize = 20;

populationRange = max(maxNumFilters,maxFilterSize);

ga_call_create_population = @(NVARS,FitnessFcn,options) create_initial_population(NVARS,FitnessFcn,options,maxNumFilters,maxFilterSize);

ga_call_crossover_population = @(parents,options,NVARS,FitnessFcn,thisScore,thisPopulation) crossover_population(parents,options,NVARS,FitnessFcn,thisScore,thisPopulation,convLayers);

%ga_call_mutate_population = @(parents,options,NVARS,FitnessFcn,state,thisScore,thisPopulation,mutationRate) mutate_population(parents ,options,NVARS,FitnessFcn,state,thisScore,thisPopulation,mutationRate,convLayers);

call_ga_fitness = @(x) ga_fitness(x,convLayers,trainFaceData,testFaceData,imgLength,imgWidth);

%% Genetic Algorithm Options Setup
% First, we will create an options container to indicate a custom data type
% and the population range.
options = optimoptions(@ga, 'PopulationType', 'custom','InitialPopulationRange', ...
                            [1;populationRange]);                        
%%
% We choose the custom creation, crossover, mutation, and plot functions
% that we have created, as well as setting some stopping conditions.
options = optimoptions(options,'CreationFcn',ga_call_create_population, ...
                        'CrossoverFcn',ga_call_crossover_population, ...
                        'MutationFcn',@mutate_population, ...
                        'MaxGenerations',10,'PopulationSize',11, ...
                        'MaxStallGenerations',100,'UseVectorized',true);                    
options = optimoptions(options,'PlotFcn', {  @gaplotbestf @gaplotscores });
options = optimoptions(options,'UseParallel', true);                    
%%
% Finally, we call the genetic algorithm with our problem information.

numberOfVariables = convParams;
[x,fval,reason,output] = ...
    ga(call_ga_fitness,numberOfVariables,[],[],[],[],[],[],[],options)
%%
%save the final configuration for CNN obtained
save('finalConfig.mat','x');