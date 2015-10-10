function s = setup_serial(com_port,baud_rate,handles)

%Function inputs:
%com_port = the com port string, ex: 'COM24'
%baud_rate = the serial baud rate value, ex: 115200;


tic;

%First, create a serial object
s = serial(com_port,'BaudRate',baud_rate); %construct a serial port object with appropriate settings
fopen(s); %connect the serial port object to the serial port; ie: connect MATLAB (via the "s" object) to the Arduino
fwrite(s,'R','uint8'); %write an 'R' to the Arduino, thereby requesting that the Arduino send over another data packet to MATLAB
while (s.BytesAvailable<1)
    b = str2num(fgetl(s));
    fwrite(s,'R','uint8');
end


str2 = sprintf('Two-way serial communication established between Arduino & MATLAB.\n');

str3 = sprintf('This took %f seconds.\n',toc);

%display string in GUI Serial data text box
str2print = [get(handles.serial_info,'String'),sprintf('Done!\n'),str2,str3];
set(handles.serial_info,'String',str2print);

end %end of function


