
function [prtFile]= createPrtFile(varargin)
%
% creates a new PRT (BVQX format) file according to the parameters defined
%
% Example usage:
% createPrtFile(outputFilePath, nrOfCondition, conditions, blockSequence, outputFileName)
% 
%  Inputs:
%     outputFilePath (String) - path for the output file 'protocol.prt' - e.g. 'C:\Users\Admin\Protocol'
%     nrOfCondition (int) - number of different condition - e.g. 3 (baseline, one direction, two directions)
%     conditions (cell array size= (nrOfCondition, 4)) - array with presets for each condition i.e.
%           condition name (String), number of repetitions (int), duration of
%           each block in msec (int) and color (array with 3 ints) 
%           e.g {'baseline' 2 1000 [100 50 0]; 'oneDir' 2 1000 [195 195 195]; 'twoDir' 2 1500 [255 255 0]}
%     blockSequence (array of ints) - sequence of conditions i.e.
%           [baseline, onedir, baseline, twodir] = [1 2 1 3]
%     outputFilePath (String) - filename for the protocol output file
%     e.g. 'protocol_file'
%
%       To edit other parameters check the order of the parameters in
%       optargs and change them accordingly
%
%   Outputs:
%     File 'C:\Users\Admin\Protocol\protocol_file.prt'

%% DEFAULTS
%  path for the output protocol file
outputFilePath = fullfile(pwd,'protocols');

% number of conditions in the protocol 
nrOfCondition = 3;

% **conditions** i. 'name', ii. number of blocks per condition, iii. ID in block sequence iv.
% duration of each block v. color per condition

conditions = {   'Baseline'      5       5       2000    [50 50 50];...
                 'AlwaysNeutral' 1       1       1000    [100 50 0];...
                 'AlwaysHappy'   1       2       1000    [0 255 255];...
                 'AlwaysSad'     1       3       1000    [255 0 255];...
                 'Alternate'     1       4       1000    [255 255 0]
             };

% block sequence 
blockSequence = [5, 1, 5, 2, 5, 3, 5, 4, 5];
% !!!WARNING!!!
% number of times each condition occurs must be equal to the number set in conditions **ii.** 

% filename for the protocol output file
outputFileName = 'protocol_avatars_static_images';

% version of the protocol file
versionNum = 2;

% resolution time (e.g. 'msec' or 'vol')
resTime = 'msec';

% name of the experiment
experimentName = 'protocol_avatars_static_images';

% colors 
backgroundColor =  [0 0 0];
textColor = [255 255 202];
timeCourseColor = [255 255 255];
timeCourseThick = 3;
referenceFuncColor = [192 192 192];
referenceFuncThick = 2;


%% set defaults for optional inputs
optargs = {outputFilePath,...
    nrOfCondition,...
    conditions,...
    blockSequence,...
    outputFileName,...
    versionNum, ...
    resTime,...
    experimentName,...
    backgroundColor,...
    textColor,...
    timeCourseColor,...
    timeCourseThick,...
    referenceFuncColor,...
    referenceFuncThick};

%% set new values to parameters struct
optargs(1:nargin) = varargin;

[outputFilePath,...
    nrOfCondition,...
    conditions,...
    blockSequence,...
    outputFileName,...
    versionNum, ...
    resTime, ...
    experimentName, ...
    backgroundColor, ...
    textColor, ...
    timeCourseColor, ...
    timeCourseThick,...
    referenceFuncColor,...
    referenceFuncThick] = optargs{:};


%% Create new file using parameters

% use Time pointer to identify file in the experiment
timePtr = clock;

% create protocol file
prtFile = fopen( fullfile(outputFilePath,...
    [outputFileName '_' num2str(timePtr(4)) '_' num2str(timePtr(5)) '-' ...
    num2str(timePtr(3)) '_' num2str(timePtr(2)) '_' num2str(timePtr(1)) '.prt']), 'wt' );

% delimiter tab
del = char(9); 

%% FILE HEADER
fprintf(prtFile, 'FileVersion:%s%s%i \n\n', del, del, versionNum);
fprintf(prtFile, 'ResolutionOfTime:%s%s \n\n', del, resTime);
fprintf(prtFile, 'Experiment:%s%s%s \n\n', del, del, experimentName);
fprintf(prtFile, 'BackgroundColor:%s%s \n\n', del, num2str(backgroundColor));
fprintf(prtFile, 'TextColor:%s%s%s \n', del, del, num2str(textColor));
fprintf(prtFile, 'TimeCourseColor:%s%s \n', del, num2str(timeCourseColor));
fprintf(prtFile, 'TimeCourseThick:%s%i \n', del, timeCourseThick);
fprintf(prtFile, 'ReferenceFuncColor:%s%s \n', del, num2str(referenceFuncColor));
fprintf(prtFile, 'ReferenceFuncThick:%s%i \n\n', del, num2str(referenceFuncThick));
fprintf(prtFile, 'NrOfCondition:%s%s%i \n \n \n', del, del, nrOfCondition);

%% Write conditions in the protocol file
condsNum = size(conditions,1);

% variable initialization
condition_temp = zeros(1,condsNum);

for i = 1:condsNum
    condition_temp(i) = conditions{i,3};
end

% for the condition **c**
for c = 1:condsNum
    % write the name of the conditions
    fprintf(prtFile, '%s \n', conditions{c,1}); 
    % total number of blocks per condition
    numBlocks = conditions{c,2};
    % write the number of blocks
    fprintf(prtFile, '%i \n', numBlocks); 
    % position of each condition in the block sequence
    [~,blocksPerCondIdx] = find(blockSequence==conditions{c,3});
    % duration of the c_th block
    blockDur = conditions{c,4};
    
    % for each block of the c_th condition determine *start* and *end* timestamp
    for b = 1:length(blocksPerCondIdx)
        % start of each block
        startTime = computeStartTime(blocksPerCondIdx(b), ...
            blockSequence, ...
            conditions, ...
            condition_temp);
        % end of each block
        endTime = startTime + blockDur;
        % write to file
        fprintf(prtFile, '%i%s%i \n', startTime, del, endTime);
    end
    % Color for each condition
    fprintf(prtFile, 'Color:%s%i %i %i \n', del, conditions{c,5});

    fprintf(prtFile, '\n');
end

fclose(prtFile);

end

function [startTime] = computeStartTime (b, blockSequence, conditions, condition_temp)

startTime = 0;

if b == 1
    % beginning of the experiment
    startTime = 0; 
else
    for i = 1:(b-1)
        % add the duration of the previous blocks
        startTime = startTime + conditions{find(condition_temp==blockSequence(i)),4}; 
    end
end

end

