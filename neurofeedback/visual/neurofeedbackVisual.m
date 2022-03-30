function outputs = neurofeedbackVisual(framesPath, syncBoxEnabled, outputFilePath, outputFileName, eegEnabled)
%
% Runs the static image localizer
%
% Example usage:
% neurofeedbackAuditory('../data/dynamic-images/', 1, 'C:\neurofeedback_protocols', 'VisualFeedbackPrt', 0)
% 
%  Inputs:
%     framesPath (string) - path to the folder with dynamic-expressions (default: '../data/dynamic-images/')
%     syncBoxEnabled (bool) - determines if the fMRI syncbox is connected or not
%           (0 or 1)
%     outputFilePath (string) - path to the folder to save protocols (default: '../outputs/protocols')
%     outputFileName (string) - name of the protocol file (default: 'Auditory_feedback_protocol')
%     eegEnabled (bool) - determines if the EEG box is connected or not (0
%     or 1)
%
%   Outputs:
%     N/A
%
% check src/utils/helpers/createPrtFile for example

if nargin < 5
    % Send trigger to EEG port
    eegEnabled = 0;
    
    % TRIGGER decoding (trigger associated to each facial expression/image)
    % ----------------------------------
    %     1 - Neutral
    %     2 - Happy
    %     3 - Sad
    %     4 - Alternated
    %     6 - Beep
    % ----------------------------------

end

if nargin < 4
    % name of the protocol file
    outputFileName = 'Visual_feedback_protocol';
end

if nargin < 3
    % change to path folder @ stimulus presentation PC
    outputFilePath =  '../outputs/protocols';
end

if nargin < 2
    syncBoxEnabled = 0;
end

if nargin < 1
    framesPath = '../data/dynamic-images/';
end



    % =======================================
    %%  Configuration and presets
    % =======================================

    configs = init(); % get configs
    
    logger = NFLogger.getLogger();
    
    configs.eegEnabled = eegEnabled;
    configs.framesRateAnimation = 20;
    
    
    configs.conditionPerTR = [];
    for i = 1:numel(configs.blockSeq)
        configs.conditionPerTR = [configs.conditionPerTR  ones(1,configs.samplesPerBlock) * configs.blockSeq(i)];
    end
    
    configs.baselineIdx = zeros(1, length(configs.blockSeq)*configs.samplesPerBlock);
    for i = 1:numel(configs.blockSeq)
        if configs.blockSeq(i) == configs.baselineCondition
            blockStart = (i-1)*configs.samplesPerBlock + 1;
            configs.baselineIdx( blockStart + configs.shiftBegin : blockStart + configs.samplesPerBlock - 1 + configs.shiftEnd ) = 1;
        end
    end
    if length(configs.baselineIdx) > configs.samplesPerBlock * configs.numBlocks
        configs.baselineIdx(configs.samplesPerBlock * configs.numBlocks + 1 : end ) = [];
    end
    
    
    
    
    
    % ---------------------------------------
    % definition of variables /  PROTOCOL
    % ---------------------------------------
    configs.feedbackIntervalPoints = 3;

    
    
    outputs = struct();
    outputs.meanROIActivation = [];
    outputs.meanROIActivationTimestamp = [];
    outputs.feedback = [];
    outputs.feedbackTimestamp = [];
    outputs.blocksDurations = [];
    outputs.expressionToUse = 2;
    
    outputs.currentFeedback = 0;
    % ---------------------------------------
    % create protocol file 
    % ---------------------------------------

    % generate a set of different RGB codes to design protocol
    colorsProtocol = round(jet(configs.numCond+1) * 255); % generate a set of different RGB codes to design protocol
    convConst = 1000; % convert seconds to miliseconds
    conditionsPRT = {   'Neutral'     (configs.numRep*(configs.numCond)+1)   1     configs.blockDuration*convConst     colorsProtocol(1,:);...
                        'Happy'       configs.numRep                 2     configs.blockDuration*convConst     colorsProtocol(2,:);...
                        'Sad'         configs.numRep                 3     configs.blockDuration*convConst     colorsProtocol(3,:);...
                        'Alternate'   configs.numRep                 4     configs.blockDuration*convConst     colorsProtocol(4,:)};

                   
                    
    % create new PRT file
%     createPrtFile(outputFilePath, configs.numCond+1, conditionsPRT, configs.blockSeq, outputFileName);

   
    % =======================================
    %%  stimuli presentation
    % =======================================

       
    % preload frames
    configs.expressionFrames = struct();
    for condition = 2:3
        configs.expressionFrames = setfield(configs.expressionFrames, sprintf('cond_%d', condition), loadFramesOfExpression(configs, framesPath, condition));
    end
    
    % ---------------------------------------
    % Open connection with MRI scanner
    % ---------------------------------------

    if syncBoxEnabled
        syncBoxHandle = openSyncBoxPort( configs.SYNCBOX_PORT );
    end

 
    % ---------------------------------------
    % Open audio channel
    % ---------------------------------------
    configs.pahandle = prepareAudioCard();


    
    % ------------------
    % open the screen
    % ------------------
    
    screens=Screen('Screens');
    screenNumber=max(screens);
    
    [configs.w, ~]=Screen('OpenWindow', screenNumber, 0, [], 32, 2);
    
    % ------------------
    % Wait for MRI software trigger to start stimulus presentation
    % ------------------
    
    if syncBoxEnabled
        % waits for trigger during 5 minutes (300/60)
        [gotTrigger, logdata.triggerTimeStamp]=waitForTrigger(syncBoxHandle,1,300);
        
        if gotTrigger
            logger.log('Trigger OK! Starting stimulation...', 1);
            
            HideCursor;
        else
            logger.log('Absent trigger. Aborting...', 1);
            Screen('Close');
            sca; return
        end
    else
        KbWait;
    end

    logger.log('Visual run started');
    % =======================================
    %%  Import/Load Frames
    % =======================================

    % load neutral image
    configs.neutralFaceImage = imread([framesPath '1_neutral/neutral00.jpg']);
    presentImage (configs.w, configs.neutralFaceImage);
   

    
    outputs = imagery( configs, outputs, @visualInstruction, @computeVisualFeedback );
    
    
    ShowCursor;
    Screen('CloseAll');
    IOPort('CloseAll');
    
    % Close the audio device:
    PsychPortAudio('Close', configs.pahandle);

    
end
