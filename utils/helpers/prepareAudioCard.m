function [ pahandle ] = prepareAudioCard( )
% TODO comment here

    % Perform basic initialization of the sound driver:
    InitializePsychSound;
    nrchannels = 2;
    freq = [];
    try
        % Try with the 'freq'uency we wanted:
        pahandle = PsychPortAudio('Open', [], [], 0, freq, nrchannels);
    catch
        % Failed. Retry with default frequency as suggested by device:
        fprintf('\nCould not open device at wanted playback frequency of %i Hz. Will retry with device default frequency.\n', freq);
        fprintf('Sound may sound a bit out of tune, ...\n\n');

        psychlasterror('reset');
        pahandle = PsychPortAudio('Open', [], [], 0, [], nrchannels);
    end


end

