function [blockSequence] =  generateRandomVector(conditions, numRep, baseline)
%
% Generates a random vector of pairs baseline + condition for
% numCondixions * numRep blocks
%
% Example usage:
% generateRandomVector( [1 2], 3, 5 )
% returns [5 1 5 2 5 2 5 1 5 2 5 1 5] # example
% 
%  Inputs:
%     numConditions - number of conditions to intercalate with fixation
%                      cross blocks (1:Conditions)
%     numRep - number of repetitions 
%
%   Outputs:
%     blockSequence - the sequence generated

% initialization
blockSequence = [];

defaultVec = ones(1,length(conditions) * 2) * baseline; % fixation cross 


%create chaos vetor starts with 1 and ends with 1
for i = 1:numRep
    conds_temp = conditions(randperm(length(conditions)));
    
    defaultVec(2:2:end) = conds_temp;
    blockSequence = [blockSequence, defaultVec];
end

blockSequence = [blockSequence, baseline]; % Add a fixation at the end of the run

end