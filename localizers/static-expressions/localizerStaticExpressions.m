function localizerStaticExpressions(framesPath, syncBoxEnabled, outputFilePath, outputFileName, eegEnabled)
%
% Runs the static image localizer
%
% Example usage:
% localizerStaticExpressions('../data/static-images/', 0, '../outputs/protocols', 'staticExpressionsPrt', 0)
% 
%  Inputs:
%     framesPath (string) - path to the folder with static-expressions (default: '../data/static-images/')
%     syncBoxEnabled (bool) - determines if the fMRI syncbox is connected or not
%           (0 or 1)
%     outputFilePath (string) - path to the folder to save protocols (default: '../data/protocols')
%     outputFileName (string) - name of the protocol file (default: 'Static_expressions_protocol')
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
    %     5 - Fixation
    % ----------------------------------

end

if nargin < 4
    % name of the protocol file
    outputFileName = 'Static_expressions_protocol';
end

if nargin < 3
    % change to path folder @ stimulus presentation PC
    outputFilePath =  '../outputs/protocols';
end

if nargin < 2
    syncBoxEnabled = 0;
end

if nargin < 1
    framesPath = '../data/static-images/';
end



% ---------------------------------------
%%  Configuration and presets
% ---------------------------------------

configs = init();

numRep = 4; % number of Repetitions
numOfCond = 4; %number of conditions - 1. always neutral, 2. always happy, 3. always sad, 4 alternate
inblockRep = 16; %in block repetition (even number is mandatory)

% define alternate conditions
alternateVector = ones(1,inblockRep)*2 ;
alternateVector(2:2:inblockRep) = 3;

% conditions description
conds = [ones(1,inblockRep);...
    ones(1,inblockRep)*2;...
    ones(1,inblockRep)*3;...
    alternateVector];

% total number of blocks
numBlocks = numRep*(numOfCond)*2+1; % number of blocks

%% Stimuli and interstimuli time

% InterExpression duration
isi = 0.200; % in miliseconds
% Expression duration
exprDur = 0.800;

% Fixation Duration
fixDur = 10.000;

% duration of each block in miliseconds
blockDur = (exprDur+isi)*inblockRep;

%% Open connection with MRI scanner and EEG setup
if syncBoxEnabled
    syncBoxHandle = openSyncBoxPort(configs.SYNCBOX_PORT);
end


%% Import/Load Frames
foldersFrames_temp = dir(fullfile(pwd,framesPath));
counter = 0;

expressions = [];

for i =3:numel(foldersFrames_temp)
    counter = counter+1;
    
    % name of the folder with frames
    conditions(counter)={foldersFrames_temp(i).name};
    % path to frames from each expressions
    pathFrames_expressions(counter) = {fullfile(framesPath, conditions{counter}, '*.jpg')};
    % filenames for each frame/expression
    fileName_temp = dir(pathFrames_expressions{counter});
    
    expressionSingle = [];
    for f = 1:length(fileName_temp)
        
        framePath_temp = fullfile(framesPath, conditions{counter}, fileName_temp(f).name);
        frameData = imread(framePath_temp);
        expressionSingle = [expressionSingle {frameData}];
    end
    expressions = [expressions {expressionSingle}];
end

% conditions has the name of the expressions ('happy', 'sad', 'neutral')
% frameArray has all the frames loaded

%% Create random display of conditions and PRT file

blockSequence = generateRandomVector( 1:4, numRep, 5 ); 

% randNumCond_temp = numOfCond(randperm(length(numOfCond))); % Shuffle vector

% ---------------------------------------
% create protocol file
% ---------------------------------------

convConst = 1000; % convert seconds to miliseconds

conditionsPRT = {   'Baseline'      ((numRep * numOfCond)+1)  5   fixDur*convConst      [50 50 50];...
                    'AlwaysNeutral' numRep                    1   blockDur*convConst    [100 50 0];...
                    'AlwaysHappy'   numRep                    2   blockDur*convConst    [0 255 255];...
                    'AlwaysSad'     numRep                    3   blockDur*convConst    [255 0 255];...
                    'Alternate'     numRep                    4   blockDur*convConst    [255 255 0]
                };

% create new PRT file
createPrtFile(outputFilePath, numOfCond, conditionsPRT, blockSequence, outputFileName)

% ---------------------------------------
%%  stimulus presentation
% ---------------------------------------


try
    
    % ------------------
    % open the screen
    % ------------------
    screens=Screen('Screens');
    screenNumber=max(screens);
    
    [w, wRect]=Screen('OpenWindow',screenNumber, 0,[],32,2);
    
    % presets for fixation cross
    [X,Y] = RectCenter(wRect);
    FixCross = [X-1,Y-20,X+1,Y+20;X-20,Y-1,X+20,Y+1];
    
    %% Wait for MRI software trigger to start stimulus presentation
    
    if syncBoxEnabled
        % waits for trigger during 5 minutes (300/60)
        [gotTrigger, logdata.triggerTimeStamp]=waitForTrigger(syncBoxHandle,1,300);
        
        if gotTrigger
            disp('Trigger OK! Starting stimulation...');
            
            HideCursor;
        else
            disp('Absent trigger. Aborting...');
            Screen('Close');
            sca; return
        end
    else
        % waits keypress
        Screen('DrawText', w, 'Experiment is ready', 50,50,255);
        Screen('Flip', w);
        
        KbWait;
    end
    
    % ---------------------------------------
    %% Start experiment
    % ---------------------------------------

    startExperiment = GetSecs();
    for numIt = 1:numBlocks
        
        startBlock = GetSecs();
       

        if blockSequence(numIt) == 5
            % draw fixation cross
            Screen('FillRect', w, [255,255,255], FixCross');
            
            startTime = GetSecs;
            
            Screen('Flip', w);

            % ------------------
            % Send EEG trigger
            % ------------------

            if eegEnabled
                sendTrigger( blockSequence(numIt), configs );
            end

            % duration of the fixation cross
            setTimer(startTime, fixDur)
 
        else
            expSeq = conds(blockSequence(numIt),:);
            
            % Randomize images
            randSeq = randperm(numel(expressions{1}));
            
            for f = 1:numel(expSeq)
                % PRESENT IMAGE   
                startTime = GetSecs;
                
                % match (1.always neutral 2.always happy, 3. always sad 4. alternate - 2/3) block 
                % with correct folder (1.neutral, 2. happy and 3. sad)
                imageToDisp = expressions{expSeq(f)}(randSeq(f));
                
                textureIndex = Screen('MakeTexture', w,cell2mat(imageToDisp));
                % start projection
                
                Screen('DrawTexture', w, textureIndex);
                
                % !!! Important (low vram pc)
                Screen('Close', textureIndex)
                
                % SHOW IMAGE
                
                
                % Flip to the screen
                Screen('Flip', w);
                
                % ------------------
                % Send EEG trigger
                % ------------------
                if eegEnabled
                    sendTrigger(expSeq(f), configs);
                end
                
                setTimer(startTime, exprDur)
                

                % SHOW BLACK SCREEN
                
                % Present black screen
                % Now fill the screen black
                Screen('FillRect', w, [0 0 0]);
                
                
                startTime = GetSecs;
                % Flip to the screen
                Screen('Flip', w);
                
                setTimer(startTime, isi);
                
            end
            
            
        end
        stopBlock=GetSecs();
        stopBlock-startBlock
    end
    

    stopExperiment=GetSecs();
    
    stopExperiment-startExperiment
    Screen('CloseAll');
    
catch
    disp('ERROR LOADING/DISPLAYING IMAGES!!!')
end

ShowCursor;

end






