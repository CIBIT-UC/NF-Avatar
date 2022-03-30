function auditoryInstructionWithExpression( configs, expressionImage, condition, instructionEndTime)
% Play instruction sound

    presentImage( configs.w, expressionImage); % show neutral face

    audiofile = sprintf('%s/instruction_%d.wav', configs.SOUND_PATH, condition); 
    playSoundFromFile(audiofile, configs.pahandle); % play instruction sound

    waitTimeUntil(instructionEndTime);

    presentImage( configs.w, configs.BLACK_IMAGE ); % in the end, show black screen

end