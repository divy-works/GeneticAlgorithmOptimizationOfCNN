function []=genConvnetConfig(numConvLayers,convFilterNumInLayers,convFilterSizeInLayers,imgLength,imgWidth)

if(exist('tempScript.m','file'))
    delete tempScript.m
end

q = char(39);%to insert single quote

fid = fopen('tempScript.m','w');
fprintf(fid,'%%\n');
fprintf(fid,strcat('layers = [imageInputLayer([',string(imgLength),',',string(imgWidth),' 1])\n'));
for i=1:numConvLayers
    fprintf(fid,strcat('convolution2dLayer(', string(convFilterSizeInLayers(i)),',',...
        string(convFilterNumInLayers(i)),',',q,'Padding',q,',',...
        string(floor(convFilterSizeInLayers(i)/2)),')\n'));
    fprintf(fid,'reluLayer\n');
    fprintf(fid,strcat('maxPooling2dLayer(2,',q,'Stride',q,',2)\n'));
end
fprintf(fid,'fullyConnectedLayer(40)\n');
fprintf(fid,'softmaxLayer\n');
fprintf(fid,'classificationLayer()];');
fprintf(fid,'%%/n');
fclose(fid);
end
