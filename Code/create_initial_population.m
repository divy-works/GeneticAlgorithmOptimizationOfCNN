function pop = create_initial_population(NVARS,FitnessFcn,options,maxNumFilters,maxFilterSize)
% Create the initial population for GA.
% Create Cell of populationSize
% each cell is an individual containing an array
% first two elements of array are number of filters in each layer
% next two elements are the filter size used in each layer

totalPopulationSize = options.PopulationSize;
n = NVARS/2;
pop = cell(totalPopulationSize,1);
disp('Starting Generation of Initial Population');
for i = 1:totalPopulationSize
    pop{i} = [randi([1 maxNumFilters],[1 n]) randi([1 maxFilterSize],[1 n])];
end
save('initialPop.mat','pop');
disp('Generation of Initial Population Completed');
