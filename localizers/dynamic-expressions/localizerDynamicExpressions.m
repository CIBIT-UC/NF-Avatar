function localizerDynamicExpressions(framesPath, syncBoxEnabled, outputFilePath, outputFileName, eegEnabled)
%
% Runs the dynamic image localizer
%
% Example usage:
% localizerDynamicExpressions('../data/dynamic-images/', 0, '../data/protocols', 'dynamicExpressionsPrt', 0)
% 
%  Inputs:
%     framesPath (string) - path to the folder with static-expressions (default: '../data/dynamic-images/')
%     syncBoxEnabled (bool) - determines if the fMRI syncbox is connected or not
%           (0 or 1)
%     outputFilePath (string) - path to the folder to save protocols (default: '../data/protocols')
%     outputFileName (string) - name of the protocol file (default: 'Dynamic_expressions_protocol')
%     eegEnabled (bool) - determines if the EEG box is connected or not (0
%     or 1)
%
%   Outputs:
%     N/A


if nargin < 5
    % Send trigger to EEG port
    eegEnabled = 0;
    
    % TRIGGER decoding (trigger associated to each facial expression/image)
    % ----------------------------------
    %     1 - Neutral
    %     2 - Happy
    %     3 - Sad
    %     4 - Alternate
    %     6 - movement
    % ----------------------------------

end

if nargin < 4
    % name of the protocol file
    outputFileName = 'Dynamic_expressions_protocol';
end

if nargin < 3
    % change to path folder @ stimulus presentation PC
    outputFilePath =  '../outputs/protocols';
end

% if nargin < 2
    syncBoxEnabled = 0;
% end

if nargin < 1
    framesPath = '../data/dynamic-images/';
end


% ---------------------------------------
%%  Configuration and presets
% ---------------------------------------

configs = init();

logger = NFLogger.getLogger();

% ---------------------------------------
% definition of variables
% ---------------------------------------

% number of Repetitions
numRep = 8; 
% number of conditions ( i.neutral, ii.happy, iii.sad, iv.alternate, v.movement)
numCond = 5; 
% number of expressions per block
numExp = 4;

% define **alternate** condition (ii.happy and iii.sad)
alternateVector = ones(1,numExp)*2 ;
alternateVector(2:2:numExp) = 3;

% conditions description
conds = [   ones(1,numExp);...      % displays #numExp neutral expressions      (1)
            ones(1,numExp)*2;...    % displays #numExp happy expressions        (2)
            ones(1,numExp)*3;...    % displays #numExp sad expressions          (3)
            alternateVector;...     % displays #numExp alternating expressions  (4)
            ones(1,numExp)*4        % displays #numExp movement segments        (5)
        ];

% number of blocks
numBlocks = numRep*numCond;

% colors per condition
%colorsProtocol = jet(numOfCond); % generate a set of different RGB codes to design protocol


%% Stimuli and interstimuli time

% duration of each block in miliseconds
faceExpreDuration = 2;
activationBlockDur = faceExpreDuration * numExp;

% frames/videos variables
numFramesPerVideo = 60;
frameDuration = 2/numFramesPerVideo;

% generate a set of different RGB codes to design protocol
colorsProtocol = round(jet(numCond) * 255);

%% Open connection with MRI scanner and EEG setup
if syncBoxEnabled
    syncBoxHandle = openSyncBoxPort( configs.SYNCBOX_PORT );
end


% =======================================
%%  Import/Load Frames
% =======================================

foldersFrames_temp = dir(framesPath);
counter = 0;

expressions = [];

for i =3:numel(foldersFrames_temp)
    counter =counter+1;
    
    % name of the folder with frames
    conditions(counter)={foldersFrames_temp(i).name};
    % path to frames from each expressions
    pathToFrames_expressions(counter) = {fullfile(framesPath, conditions{counter}, '*.jpg')};
    % filenames for each frame/expression
    fileName_temp = dir(pathToFrames_expressions{counter});
    
    expressionSingle = [];
    for f = 1:length(fileName_temp)
        
        framePath_temp = fullfile(framesPath, conditions{counter}, fileName_temp(f).name);
        frameData = imread(framePath_temp);
        expressionSingle = [expressionSingle {frameData}];
    end
    expressions = [expressions {expressionSingle}];
end

%% Create random display of conditions and PRT file

blockSequence = [];

for i = 1:1:numRep
    blockSequence = [blockSequence randperm(numCond)];
end

% ---------------------------------------
% create protocol file
% ---------------------------------------

convConst = 1000; % convert seconds to miliseconds

conditionsPRT = {   'Neutral'           numRep  1   activationBlockDur*convConst    colorsProtocol(1,:);...
                    'Happy'             numRep  2   activationBlockDur*convConst    colorsProtocol(2,:);...
                    'Sad'               numRep  3   activationBlockDur*convConst    colorsProtocol(3,:);...
                    'Alternate'         numRep  4   activationBlockDur*convConst    colorsProtocol(4,:);...
                    'Movement'          numRep  5   activationBlockDur*convConst    colorsProtocol(5,:)...
                    };


% create new PRT file
createPrtFile(outputFilePath, numCond, conditionsPRT, blockSequence, outputFileName)


% =======================================
%%  stimuli presentation
% =======================================


try
    % ------------------
    % open the screen
    % ------------------
    screens=Screen('Screens');
    screenNumber=max(screens);
    
    [w, wRect]=Screen('OpenWindow',screenNumber, 0,[],32,2);
    
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
        Screen('DrawText', w, 'Experiment is ready', 50,50,255);
        Screen('Flip', w);
        
        KbWait;
        HideCursor();
    end

    
    logger.log('Dynamic localizer started');
    
    
    % ------------------
    % Starting presentation of stimuli
    % ------------------
    StartExpTime = GetSecs;
    StartTime = GetSecs;
    StopTime = 0;
    
    for numIt = 1:numBlocks
        tic
        for n = 1:length(conds(1,:))
            
            logger.log(sprintf('Starting Run: #%d - Condition #%d', numIt, n));
            
            numExpression = (conds(blockSequence(numIt),n));
            startExp = GetSecs;
            % If baseline do flip fixation cross
            
            expreAll = expressions{numExpression}; %TODO trigger do movement diff da pasta
            
            % ------------------
            % Send EEG trigger
            % ------------------
            if eegEnabled
                if numExpression == 4
                    sendTrigger(6, configs);
                else 
                    sendTrigger(numExpression, configs);
                end
                logger.log(sprintf('Trigger sent to EEG: %d', numExpression));
            end
            
            
            for i = 1 : numFramesPerVideo
                
                % Import image and and convert it, stored in
                % MATLAB matrix, into a Psychtoolbox OpenGL texture using 'MakeTexture'
                imageToDisp = expreAll{i};
                
                textureIndex = Screen('MakeTexture', w,imageToDisp);
                Screen('DrawTexture', w, textureIndex);
                
                % !!! Important (low vram pc)
                Screen('Close', textureIndex)
                
                % wait for frameDuration
                setTimer(StartTime, frameDuration)
                
                StartTime = GetSecs;
                Screen('Flip', w);
                
                StopTime = GetSecs;
                
            end
            
            stopExp = GetSecs;
            stopExp-startExp
        end
        disp ('duration of each block : ')
        toc
    end
    StopExpTime = GetSecs;
    
    logger.log(sprintf('Duration of the localizer: %.4f', StopExpTime - StartExpTime), 1);
    
    Screen('CloseAll');
    ShowCursor();
catch
    disp('ERROR LOADING/DISPLAYING IMAGES!!!')
    ShowCursor();
end


end




