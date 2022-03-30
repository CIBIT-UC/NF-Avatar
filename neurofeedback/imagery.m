function [outputs] = imagery (configs, outputs, instructionFcn, feedbackFcn)

    logger = NFLogger.getLogger();
    % ---------------------------------------
    % Open connection with TBV server
    % ---------------------------------------
    tbvNetInt = TBVNetworkInterface( TBVclient( configs.TBV_IP, configs.TBV_PORT ) );
    tbvNetInt.createConnection();

    % ---------------------------------------
    % IMAGERY TASK - NEUROFEEDBACK
    % ---------------------------------------
    outputs.startTimeStamp = GetSecs;
    
    for k=1:configs.numBlocks % block loop
        
        startBlockTime = GetSecs;
        
        logger.log(['starting block #' num2str(k)], 1);
        
        condition = configs.blockSeq(k);
        
        
        instructionFcn( configs, outputs, condition, startBlockTime + configs.blockInstructionDuration);
        
        logger.log(sprintf('instruction given for condition: %d', condition), 1);
       
        if configs.eegEnabled
            sendTrigger(condition, configs);
            logger.log(sprintf('EEG trigger sent: %d', condition), 1);
        end
        
        playBeep(configs.pahandle);

        blockSamplePoint = 0;
    
        blockEndTime = startBlockTime + configs.blockDuration;
        
        if configs.EEG_ONLY
            waitTimeUntil(blockEndTime);
        else
        
 
            while GetSecs < blockEndTime % level 0 (fixation) duration AND break statement


                % While time available to FETCH NEW DATA
                if  (blockEndTime-GetSecs) > 1


                    % check for NEW DATA AVAILABLE @ server
                    currentSample = tbvNetInt.tGetCurrentTimePoint();

                    % if new data available - CONTINUE!
                    if currentSample > configs.lastSample

                        configs.lastSample = configs.lastSample + 1;


                        [outputs.meanROIActivation(configs.lastSample), timepoint] = tbvNetInt.tGetMeanOfROIAtTimePoint(0,configs.lastSample-1);
                        outputs.meanROIActivationTimestamp(configs.lastSample) = GetSecs - outputs.startTimeStamp; %exact timeStamp of the last new timepoint

                        if outputs.meanROIActivation(configs.lastSample) == -1
                            % POSSIBLE ERROR - TO DO!
                            fprintf('At least one of the ROIs is unavailable ROI available! \n')
                        end


                        if floor( (configs.lastSample-1) / (configs.blockDuration / configs.TR))  == k-1
                             blockSamplePoint = blockSamplePoint + 1;
                        end



                        % compute feedback based on NEW DATA
                        outputs = feedbackFcn(configs, outputs, blockSamplePoint);
                        log(configs, outputs, currentSample, timepoint); %debug

                    else
                        pause (.2); % try again in .5 seconds
                    end

                end

            end
        end
        
        outputs.blocksDurations(k) = GetSecs - startBlockTime;
        blockDuration = ['Block #' num2str(k) ' duration: ' num2str(GetSecs - startBlockTime)];
        logger.log(blockDuration, 1);

        
    end
    
    outputs.imageryDuration = GetSecs - outputs.startTimeStamp;
    logger.log(['Finnished imagey. Duration: ' outputs.imageryDuration], 1);
    tbvNetInt.closeConnection();

end

function log(configs, outputs, currentSample, timepoint)

    if length(outputs.feedback) < configs.lastSample
        outputs.feedback(configs.lastSample)=-1;
    end

    display (['currentSample - ' num2str(currentSample)] )
    display (['lastSample - ' num2str(configs.lastSample)])
    display (['timepoint  - ' num2str(timepoint)])
    display (['activation - ' num2str(outputs.meanROIActivation(configs.lastSample))]);
    display (['feed - ' num2str(outputs.feedback(configs.lastSample))]);
    fprintf('\n')
    
    logger = NFLogger.getLogger();
    logger.log(sprintf('Feedback point #%d (%.4fs): activation - %.2f | feedback - %.2f', configs.lastSample, ...
        outputs.meanROIActivationTimestamp(configs.lastSample), outputs.meanROIActivation(configs.lastSample), outputs.feedback(configs.lastSample)));
    
    outputs.meanROIActivationTimestamp
end