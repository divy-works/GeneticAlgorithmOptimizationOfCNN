function mutationChildren = mutate_population(parents ,options,NVARS,FitnessFcn, state, thisScore,thisPopulation,mutationRate)

convLayers = 3;
mutationChildren = cell(length(parents),1);
for i=1:length(parents)
    parent = thisPopulation{parents(i)};
    child = parent;
    p_numFilter = randi([1 convLayers],[1 2]);
    
    child(p_numFilter(1)) = parent(p_numFilter(2));
    child(p_numFilter(2)) = parent(p_numFilter(1));
    
    p_sizeFilter = randi([convLayers+1 2*convLayers],[1 2]);
    
    child(p_sizeFilter(1)) = parent(p_sizeFilter(2));
    child(p_sizeFilter(2)) = parent(p_sizeFilter(1));
    
    mutationChildren{i} = child;
end
disp('End of Mutation Function');
save('GA_Population.mat','thisPopulation','thisScore');