%Gabriel Staples
%Connect MATLAB to an Arduino to communicate, via serial, back and forth!
%13 Feb. 2014

%for more info. & help see "help serial"

% clc
% close all
% clear all

%% Close and delete any and all open serial ports in MATLAB
close_serial

%% Establish Two-Way Communication Between the Arduino & MATLAB
com_port = get(handles.com_port,'String');
%com_port = '/dev/tty.usbmodem1411';
s = setup_serial(com_port,9600,handles); %establish serial communications with the Arduino, using the specified COM Port and Baud Rate (ex: setup_serial('COM24',115200))
                                           %Note: the "handles" variable is necessary to access the GUI stuff within the function

%% Request a data packet by sending an 'R' to the Arduino
fwrite(s,'R','uint8'); %write an 'R' to the Arduino, thereby requesting that the Arduino send over another data packet to MATLAB


% %% Prepare for Datalogging
% 
% %open up datalogging file
% clock_now = clock; %gets a 6-element vector of the current date and time in decimal form [year month day hour minute seconds]
% clock_now(6) = round(clock_now(6)); %round to the nearest second
% date_and_time_string = ''; %initialize
% for i = 1:1:6 %build up the time into a string
%     date_and_time_string = [date_and_time_string,num2str(clock_now(i),'%02d')];
%     if i==3 || i==5 %after the day, and after the minute, add an underscore in the file name
%         date_and_time_string = [date_and_time_string,'_']; %add an underscore (_)
%     end
% end
% %create the "data" directory in the current location, if necessary
% if exist('data')~=7 %if "data" does not yet exist
%     mkdir('data'); %creat it
% end
% file_name = ['data/data_',date_and_time_string,'.csv'];
% fid = fopen(file_name,'w');


%% Receive and plot data packets

% [data_is_good, packet] = receive_packet2(s);

tic
% figure(handles.PPM_plot)
% figure(1);
hold on;

%format the plot
% xlim([-19,19]) %minor adjustments for differing borders around the plot
ylim(handles.PPM_plot,[1,1000])
xlim(handles.PPM_plot,[0,60])
% set(gca, 'XTick', [-18:2:18])
title(handles.PPM_plot,'Channels in from Arduino')
xlabel(handles.PPM_plot,'time (sec)')
ylabel(handles.PPM_plot,'voltage (v)')

%Plot trail preparations
num_itns2plot = 200; %100; %number of iterations to plot.
plot_handles = NaN(num_itns2plot,8); %create an array of NaNs
handle_i = 1; %a counter (handle index) to know where to place the next value in the above arrays
loop_i = 1; %loop counter (which loop # are we on?)

%initializations necessary just for this quad simulation code
% delete_handles = false; %initialize this boolean

% while toc <= 30000 %for __ seconds
keep_going = true;
bad_packet_count = 0;
x = [];
while keep_going %go until stop button is pressed
    
    %see if the stop button has been pressed (to stop the loop)
    stop_btn_data = get(handles.stop_btn,'UserData'); %grab the stop_btn user data
    keep_going = ~stop_btn_data.stop; %when stop button is pressed, its stop_btn_data.stop value is changed from 0 to 1, so ~1 will be 0, making keep_going false, thereby
                                      %forcing the while loop to stop
    
    %see how many bytes we have available right now (should be one packet's worth, or less [45 bytes/packet last I checked])
    bytes_avail = s.BytesAvailable;
                                      
    %receive PPM data packet from Arduino
    %[data_is_good, packet] = receive_packet(s); %call the function to receive a data packet, and automatically request another
    
    b = str2num(fgetl(s));
    x = [x,b];
    fwrite(s,'R','uint8'); %write an 'R' to the Arduino, thereby requesting that the Arduino send over another data packet to MATLAB
    
    
%     if loop_i > num_itns2plot
%         delete(plot_handles(handle_i,:));
%     end
%     
    %Plot incoming data
    %t(handle_i,1) = double(packet.t)/1000; %sec
    t(handle_i,1) = handle_i * 0.5; %sec
%     if loop_i > num_itns2plot
%         %set the xlim appropriately
%         i_prev = handle_i + 1;
%         if i_prev > num_itns2plot
%             i_prev = 1;
%         end
%         xlim(handles.PPM_plot,[t(i_prev,1),t(handle_i,1)]);
%     end
    
    %plot the channel values
    plot_handles(handle_i,1) = plot(handles.PPM_plot,t(:,1),x,'b');
    %plot_handles(handle_i,2) = plot(handles.PPM_plot,t(handle_i,1),packet.chs(2,1),'+r');
    %plot_handles(handle_i,3) = plot(handles.PPM_plot,t(handle_i,1),packet.chs(3,1),'xk');
    %plot_handles(handle_i,4) = plot(handles.PPM_plot,t(handle_i,1),packet.chs(4,1),'vc');
    %plot_handles(handle_i,5) = plot(handles.PPM_plot,t(handle_i,1),packet.chs(5,1),'^m');
    %plot_handles(handle_i,6) = plot(handles.PPM_plot,t(handle_i,1),packet.chs(6,1),'>k');
    %plot_handles(handle_i,7) = plot(handles.PPM_plot,t(handle_i,1),packet.chs(7,1),'<b','MarkerFaceColor','b');
    %plot_handles(handle_i,8) = plot(handles.PPM_plot,t(handle_i,1),packet.chs(8,1),'ob','MarkerFaceColor','b');
    
    %plot the legend    
    if loop_i==1
        %legend(handles.PPM_plot,'V','Ch2','Ch3','Ch4','Ch5','Ch6','Ch7','Ch8','Location','NorthWest');
        legend(handles.PPM_plot,'V');
    end
    
    
    %assemble the data to log into a single vector
    data_to_log = [b];

    %Do one-time operations which occur only on the first loop iteration,
    %such as displaying the plot legend and writing the file header to the
    %top of the log file.
    if loop_i==1
        %plot the legend
        %legend(handles.PPM_plot,'Ch1','Ch2','Ch3','Ch4','Ch5','Ch6','Ch7','Ch8','Location','NorthWest');
        
        %Write the header to the datalogging file
        %General Header notes
       % fprintf(fid,['Arduino to MATLAB PPM Reader; by Gabriel Staples; 3 April 2014\n'...
       %              'Note: all of the channel PPM values read in by the Arduino are one or more loop iterations old; '...
       %              'ex (if we are only preloading the serial buffer with ONE data packet): the PPM values that the Arduino '...
       %              'is grabbing this loop will not be read into MATLAB until the next loop; '...
       %              'and the PPM values being recorded this loop are the values the Arduino grabbed during the previous loop.\n\n']);
        %Column Numbers
       % for i=1:1:length(data_to_log)
       %     fprintf(fid,'%d,',i);
       %     if i==length(data_to_log)
       %         fprintf(fid,'\n');
       %     end
       % end
        %Print Column Names
        %fprintf(fid,['V']);

        %one-time format string creation
       % format_string = ''; %initialize string
      %  for i = 1:1:length(data_to_log);
      %      format_string = strcat(format_string,'%3.4f'); %append the proper # of format strings
      %      if i < length(data_to_log)
      %          format_string = strcat(format_string,','); %add in the commas for all but the last one
      %      else %i = length(data_to_log)
      %          format_string = strcat(format_string,'\n'); %add in the new line command
      %      end
      %  end
                
                
    end %end of if loop_i==1
    
    %Actually log the data into the file (once per flight controller loop!)            
    %fprintf(fid,format_string,data_to_log);
    
    
    
    %display the raw values to the screen
    data_str = sprintf('SensorValue=%4d, time = %f',b, t(handle_i,1));
    set(handles.text_output,'String',data_str);
        
    %increment handle index, and roll it over if necessary
    handle_i = handle_i + 1;
%     if handle_i > num_itns2plot
%         handle_i = 1;
%     end
    
    loop_i = loop_i + 1; %increment the loop counter
    
%     drawnow; %force the plot to redraw
    %pause(.05); %wait a bit before requesting more data from the Arduino
     pause(.5);
end

data_str = sprintf('AverageValue=%.2f\nMinimumValue=%4d\nMaximumValue=%4d\n',mean(x), min(x), max(x));
set(handles.text_output,'String',data_str);
%fclose(fid); %close the datalogging file



