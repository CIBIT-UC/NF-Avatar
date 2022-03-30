function [configs] = init()

configs = struct();

configs.PC_NOVO = 1;
configs.DEBUG = 1;
configs.fullscreen = (configs.DEBUG == 0);

configs.EEG_ONLY = 0;


% adds folder structure to path


addpath('utils');
addpath('utils/helpers');
addpath('utils/network-plugin');

addpath('localizers');
addpath('localizers/static-expressions');
addpath('localizers/dynamic-expressions');

addpath('neurofeedback');
addpath('neurofeedback/visual');
addpath('neurofeedback/auditory');
addpath('neurofeedback/transfer');

addpath('logging');

% global constants
configs.SOUND_PATH = '../data/sounds/';
configs.SYNCBOX_PORT = 'COM2';
configs.EEG_PORT = hex2dec('D010'); % EEG PORT number PORTA DE BAIXO
configs.portEEG = hex2dec('D010'); % EEG PORT number


% configs.EEG_PORT = hex2dec('C030');

if configs.DEBUG % local
    configs.TBV_IP = '192.168.1.200';
    configs.TBV_PORT = 55555;
else % MRI
    configs.TBV_IP = '192.168.238.189';
    configs.TBV_PORT = 55555;
end

configs.BLACK_IMAGE = zeros([600, 800, 3]);


configs.nPointsToAvoid = 3;
configs.positiveFeedback = [configs.SOUND_PATH 'positive.wav'];
configs.negativeFeedback = [configs.SOUND_PATH 'negative.wav'];
configs.positiveFeedbackTrigger = 8;
configs.negativeFeedbackTrigger = 9;



configs.numRep = 4; % number of Repetitions
configs.numCond = 3; %number of condition 

configs.baselineCondition = 1; % identifier of baseline

configs.numBlocks = configs.numRep*(configs.numCond)*2+1; % number of blocks
configs.blockDuration=24; % block duration
configs.blockInstructionDuration = 2; % instruction interval time in seconds
configs.TR = 2; % TR of the protocol in seconds
configs.lastSample = 0;
%%%%%%%%%configs.blockSeq = generateRandomVector(2:configs.numCond+1, configs.numRep, 1); 
configs.blockSeq = [1 3 1 2 1 4 1 2 1 4 1 3 1 4 1 2 1 2 1 3 1 2 1 4 1]; 

configs.samplesPerBlock = configs.blockDuration / configs.TR;

assert( mod(configs.samplesPerBlock, 1) == 0, 'ERROR: Block duration is not a multiple of TR');


configs.shiftBegin = 3;
configs.shiftEnd = 1;

configs.nFramesPerExpression = 15;
configs.imgSequence = 3:17;

configs.maxPSC = .01;%.02; % maximal signal variation


configs.LOGS_PATH = '../outputs/logs/';


% opens parallel port driver
if configs.PC_NOVO
    configs.io64 = io64;
    status = io64(configs.io64);
end

end