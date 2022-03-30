function presentImage (w,frameData) 
%
% Prresents an image on the screen based on the psychophysics toolbox
% function 'Screen'
%
% Example usage:
% presentImage (w, frameData) 
% 
%  Inputs:
%     w (ptr) - pointer to the screen selected
%     frameData (Array) - data array (image) to display in the screen
%
%   Outputs:
%     N/A
%

    % pre-load image
    textureIndex = Screen('MakeTexture', w,frameData);
    Screen('DrawTexture', w, textureIndex);
    
    % display image
    Screen('Flip', w);

    % !!! Important (low vram pc)
    %Screen('Close', textureIndex)

end