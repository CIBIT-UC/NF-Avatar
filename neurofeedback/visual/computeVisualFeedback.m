function [outputs] = computeVisualFeedback( configs, outputs, blockSamplePoint )

    idxs = find(configs.baselineIdx(1:configs.lastSample) == 1);
    outputs.feedback(configs.lastSample) = -1;
     
    if configs.lastSample == 215
        disp('cheguei')
    end
    
     outputs.temp_samplepoint(configs.lastSample) = blockSamplePoint
        
    
    if length(idxs) > configs.samplesPerBlock-3 && blockSamplePoint > 3
        % compute baseline
       
        
        baseline = outputs.meanROIActivation( idxs( end - ( configs.samplesPerBlock - 2 ) + 1 : end ) );    % TODO baseline vs condition
        
        if configs.baselineIdx(configs.lastSample)
            baseline(end) = [];
        end
        variation = ( outputs.meanROIActivation( configs.lastSample ) - mean(baseline) ) / mean(baseline);
        variationNorm = variation / configs.maxPSC;
        feedback = min( max( variationNorm, 0 ), 1 ); 
        
        outputs.feedback(configs.lastSample) = feedback;
        outputs.feedbackTimestamp(configs.lastSample) = GetSecs;
                
        condition = configs.conditionPerTR(configs.lastSample);
        
        if condition == 2 || condition == 3
            outputs.expressionToUse = condition;
        elseif condition == 4
            outputs.expressionToUse = 2;
        end
       
        outputs = morphToExpression( configs, outputs, feedback );
        
        outputs.currentFeedback = feedback;
    end    

end
