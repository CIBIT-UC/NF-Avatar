function playSoundFromFile(filePath, pahandle) 
%
% Reproduces the sound from a wav sound file
%
% Example usage:
% playSound( 'BeautifulMusic.wav', pahandle )
% 
%  Inputs:
%     filePath - path to the sound file
%     pahandle - ainda não sei o que é, mas hei-de descobrir... #TODO
%        

    wavfilename = filePath;
    [y, fs] = wavread(wavfilename);
    
    
    sound (y, fs);
% %     playSound(y', pahandle); % uses playBeep to repruduce the sound 
end