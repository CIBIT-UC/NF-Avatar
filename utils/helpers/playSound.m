function playSound(wavedata, pahandle)
%
% Reproduces sound provided in wavedata
%
% Example usage:
% playSound( sin(1:0.1:1000), pahandle )
% 
%  Inputs:
%     wavedata - loaded sound
%     pahandle - ainda não sei o que é, mas hei-de descobrir... #TODO
%     


    nrchannels = size(wavedata,1); % Number of rows == number of channels

    % Make sure we have always 2 channels stereo output, for legacy purposes
    if nrchannels < 2
        wavedata = [wavedata ; wavedata];
    end
% % % 
% % %     % Fill the audio playback buffer with the audio data 'wavedata':
% % %     PsychPortAudio('FillBuffer', pahandle, wavedata);
% % % 
% % %     % Start audio playback
% % %     PsychPortAudio('Start', pahandle, 1, 0, 1);


sound(wavedata);

end

