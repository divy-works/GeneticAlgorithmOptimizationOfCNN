function xoverKids  = crossover_population(parents,options,NVARS,FitnessFcn,thisScore,thisPopulation,convLayers)

persistent Generation;

if(isempty(Generation))
    Generation = 0;
end

Generation = Generation + 1;

dispString = strcat('Creating Cost values for Generation : ',string(Generation));
disp(dispString);

nKids = length(parents)/2;
xoverKids = cell(nKids,1); 
index = 1;


for i=1:nKids
    
    dispString = strcat('Creating Cost values for Generation : ',string(Generation), ' ,Individual:',string(i));
    disp(dispString);

    parent = thisPopulation{parents(index)};
    parent = [fliplr(parent(1:convLayers)) fliplr(parent(convLayers+1:2*convLayers))];
    
    
    % each individual is going to have first 
    
    p_numFilters = randi([1 convLayers],[1 2]);
    p1_numFilters = min(p_numFilters);
    p2_numFilters = max(p_numFilters);
    
    child = thisPopulation{parents(index+1)};
    %child = parent(1:2*convLayers);
    
    if(p1_numFilters == p2_numFilters)
        %do nothing
    else
        child(p1_numFilters:p2_numFilters) = parent(p1_numFilters:p2_numFilters);%fliplr(child(p1_numFilters:p2_numFilters));
    end
      
    p_sizeFilters = randi([convLayers+1 2*convLayers],[1 2]);
    p1_sizeFilters = min(p_sizeFilters);
    p2_sizeFilters = max(p_sizeFilters);
    
    if(p1_numFilters == p2_numFilters)
        %do nothing
    else
        child(p1_sizeFilters:p2_sizeFilters) = parent(p1_sizeFilters:p2_sizeFilters);% fliplr(child(p1_sizeFilters:p2_sizeFilters));
    end
       
    xoverKids{i} = child;
    index = index + 2;
end
disp('End of crossover permutation');