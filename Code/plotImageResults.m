function plotImageResults(tempDataStore,testResults,actualLabel)
    offset = 0;
    count = 1;
    flag = 0;
    while(count<=10)
        subplot(5,4,count+offset);
        tempImg = imread(tempDataStore.Files{count});
        if(testResults(count) == actualLabel)
            borderColor = 'g';
        else
            borderColor = 'r';
        end
        tempImgWithShape = insertShape(tempImg,'Rectangle',[2 2 90 110],'Color',borderColor,'Linewidth',3);
        imshow(tempImgWithShape);
        title(string(testResults(count)));
        count = count + 1;
        
        flag = xor(flag,1);
        
        if(flag == 0)
            offset = offset + 2;
        end
    end 
end