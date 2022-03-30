function playBeep( pahandle )
%PLAYBEEP Summary of this function goes here
%   Detailed explanation goes here

    % beep sound
    beepSignal = sin(1:.1:1000);
    fs =44700;
    sound(beepSignal, fs);
%     playSound(beepSignal, pahandle);

end

