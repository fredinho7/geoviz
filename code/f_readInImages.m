%File reader script.
function y = func_readInImages()  
%     format longg;
%     format compact;
    %Def start root.
    start_path = fullfile(matlabroot, 'C:\');
    topLevelFolder = uigetdir(start_path);
    if topLevelFolder == 0
        return;
    end
    allSubFolders = genpath(topLevelFolder);
    remain = allSubFolders;
    listOfFolderNames = {};
    while true
        [singleSubFolder, remain] = strtok(remain, ';');
        if isempty(singleSubFolder)
            break;
        end
        listOfFolderNames = [listOfFolderNames singleSubFolder];
    end
    numberOfFolders = length(listOfFolderNames)    
    for k = 1 : numberOfFolders
        thisFolder = listOfFolderNames{k};
        fprintf('Processing folder %s\n', thisFolder);
        filePattern = sprintf('%s/*.tif', thisFolder);
        baseFileNames = dir(filePattern);
        numberOfImageFiles = length(baseFileNames);
       
        N = numberOfImageFiles;
        names = cell(1,N);
        
        if numberOfImageFiles >= 1
            for f = 1 : numberOfImageFiles
                fullFileName = fullfile(thisFolder, baseFileNames(f).name);
                fprintf(' 2  Processing image file %s\n', fullFileName);
                names{f} = fullFileName;
            end
        else
            fprintf('  Folder %s has no image files in it.. \n', thisFolder);
        end      
    end   
    y = names;
end
