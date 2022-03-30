function [ frames ] = loadFramesOfExpression( configs, path, condition  )
%LOADFRAMESOFEXPRESSION Summary of this function goes here
%   Detailed explanation goes here

    frames = [];
    folder = dir(sprintf('%s/%d_*', path, condition)); 
    folderFiles = dir(fullfile(path, folder.name));
    
    
    for i=configs.imgSequence
        
        % path to frames from each expressions
        filename = fullfile(fullfile(path, folder.name), folderFiles(i).name);

        frameData = imread(filename);

        frames = [frames {frameData}];
    end

end

