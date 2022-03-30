function [ status ] = waitTimeUntil( waitUntil )
%WAITTIMEUNTIL Summary of this function goes here
%   Detailed explanation goes here
    
    status = 1;
    while GetSecs < waitUntil 
    
        [keyisdown, ~, keycode] = KbCheck;
        key_esc=find(keycode, 1);
        if keyisdown == 1 && key_esc==KbName('Esc')
            Screen('CloseAll');
            IOPort('CloseAll');
            ShowCursor;
            Priority(0);
            status = 0;
            return
        end
    end


end

