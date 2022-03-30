function [ syncBoxHandle ] = openSyncBoxPort( port )
%
% Creates the connection to the syncbox and returns its handle
%
% Example usage:
% openSyncBoxPort('COM4')
% 
%  Inputs:
%     port (string) - name of the port to open (default: COM4)
%     
%
%   Outputs:
%     syncBoxHandle - handle for the syncbox port


    if nargin < 1
        port = 'COM2'
    end
    
    IOPort('CloseAll');
    syncBoxHandle = IOPort('OpenSerialPort', port, 'BaudRate=57600 DataBits=8 Parity=None StopBits=1 FlowControl=None');
    IOPort('Flush',syncBoxHandle);
end

