function visualInstruction( configs, outputs, condition, instructionEndTime )
% Play instruction sound

    if (outputs.expressionToUse == 2 && condition == 3 )||(outputs.expressionToUse == 3 && ( condition == 2 || condition == 4 ))
        presentImage( configs.w, configs.neutralFaceImage );
        outputs.outputs.currentFeedback = 0;
    end
    
    audiofile = sprintf( '%s/instruction_%d.wav', configs.SOUND_PATH, condition ); 
    playSoundFromFile( audiofile, configs.pahandle ); % play instruction sound

    waitTimeUntil( instructionEndTime );
    
end