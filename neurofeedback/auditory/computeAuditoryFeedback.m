function [outputs] = computeAuditoryFeedback( configs, outputs, blockSamplePoint )
    logger = NFLogger.getLogger();
    
    if configs.lastSample > 2
        % Last three samples
        buffer = outputs.meanROIActivation(configs.lastSample - 2 : configs.lastSample );    
        
        % POLYFIT to determine previous linear trend
        p = polyfit(1:3, buffer, 1);
    
        outputs.feedback(configs.lastSample) = p(1);
        outputs.feedbackTimestamp(configs.lastSample) = 0;
        if blockSamplePoint > configs.nPointsToAvoid && mod(blockSamplePoint - 5, configs.feedbackIntervalPoints) == 0
            % da feedback
            if outputs.feedback(configs.lastSample) > 0                
                audiofile = configs.positiveFeedback;
                trig = configs.positiveFeedbackTrigger;
            else
                audiofile = configs.negativeFeedback;
                trig = configs.negativeFeedbackTrigger;
            end
            
            outputs.feedbackTimestamp(configs.lastSample) = GetSecs - outputs.startTimeStamp;
            if configs.eegEnabled
                sendTrigger(trig, configs);
                logger.log(sprintf('Trigger sent to EEG (feedback beep): %d', trig));
            end
            playSoundFromFile( audiofile, configs.pahandle);
            
        end
        
    end    

end
