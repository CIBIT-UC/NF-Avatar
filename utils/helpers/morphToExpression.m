function outputs = morphToExpression( configs, outputs, feedback )
    newLevel = normalize( feedback, configs.nFramesPerExpression-1 );
    currentLevel = normalize( outputs.currentFeedback, configs.nFramesPerExpression-1 );
    
    frames = getfield( configs.expressionFrames, sprintf('cond_%d', outputs.expressionToUse) );
    
    incr = 1;
    if newLevel < currentLevel
        incr = -1;
    end
    for level=currentLevel:incr:newLevel
        now = GetSecs;
        presentImage( configs.w, cell2mat( frames(level + 1) ) );
        setTimer( now, 1 / configs.framesRateAnimation );
    end
    
end

function level = normalize(feedback, nframes)
    level = round( feedback * nframes );
end