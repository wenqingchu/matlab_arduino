
global x;
global now_t;
global t;
global s;
global last_toc;

now_t = now_t + round(toc-last_toc);
%% Request a data packet by sending an 'R' to the Arduino
fwrite(s,'R','uint8'); %write an 'R' to the Arduino, thereby requesting that the Arduino send over another data packet to MATLAB


%% Prepare for Datalogging 
%open up datalogging file
clock_now = clock; %gets a 6-element vector of the current date and time in decimal form [year month day hour minute seconds]
clock_now(6) = round(clock_now(6)); %round to the nearest second
date_and_time_string = ''; %initialize
for i = 1:1:6 %build up the time into a string
    date_and_time_string = [date_and_time_string,num2str(clock_now(i),'%02d')];
    if i==3 || i==5 %after the day, and after the minute, add an underscore in the file name
        date_and_time_string = [date_and_time_string,'_']; %add an underscore (_)
    end
end
%create the "data" directory in the current location, if necessary
p = mfilename('fullpath');
ppp = strfind(p,'MATLAB_to_Arduino_continue');
cd(p(1:ppp-1));
exist('data');
if exist('data')~=7 %if "data" does not yet exist
    mkdir('data'); %creat it
end
file_name = ['data/data_',date_and_time_string,'.mat'];


%% Receive and plot data packets

tic

hold on;
 
ylim(handles.PPM_plot,[1,1000])
xlim(handles.PPM_plot,[0,100])

title(handles.PPM_plot,'Signals from Arduino', 'FontSize',15)
xlabel(handles.PPM_plot,'time (sec)', 'FontSize',15)
ylabel(handles.PPM_plot,'voltage (v)', 'FontSize',15)

%Plot trail preparations
num_itns2plot = 200; %100; %number of iterations to plot.
plot_handles = NaN(num_itns2plot,8); %create an array of NaNs
handle_i = 1; %a counter (handle index) to know where to place the next value in the above arrays
loop_i = 1; %loop counter (which loop # are we on?)



keep_going = true;
bad_packet_count = 0;
x = [];
t = [];

plot_handles(handle_i,1) = plot(handles.PPM_plot,[now_t],[3],'g>', 'MarkerSize',15);
while keep_going %go until stop button is pressed
    
    %see if the stop button has been pressed (to stop the loop)
    stop_btn_data = get(handles.stop_btn,'UserData'); %grab the stop_btn user data
    keep_going = ~stop_btn_data.stop; 
    
    %see how many bytes we have available right now (should be one packet's worth, or less [45 bytes/packet last I checked])
    bytes_avail = s.BytesAvailable;
    b = str2num(fgetl(s));
    x = [x,b];
    
    
    % denoise the signal
    % returns a de-noised version X of input signal X obtained by thresholding the % wavelet coefficients. Additional output arguments [CXD,LXD] are the wavelet % decomposition structure of de-noised signal XD.（WDEN根据信号小波分解% 结构[C,L]对信号进行去噪处理，返回处理信号XD，以及XD的小波分解% 结构 {CXD，LXD}）。
    % TPTR(contains threshold selection rule)='heursure', 
    % 'heursure' is an heuristic variant of the first option
    % （选择基于Stein无偏估计理论的自适应域值的启发式改进）
    % SORH ('s' or 'h') is for soft or hard thresholding（决定域值的使用方式）
    %（决定域值是否随噪声变化） 'wname'='sym8'
    % 利用’sym8’小波对信号分解，在分解的第5层上，利用启发式SURE域值选择法对信号去噪。
    % SCAL(='onedefines multiplicative threshold rescaling:'sln' for rescaling using a single estimation 
    % of level noise based on first level coefficients（根据第一层小波分解的噪声方差调整域值）
    lev=5;
    xx=wden(x,'heursure','s','sln',lev,'sym8');
    x(length(x)) = xx(length(xx));



 
    
    
    fwrite(s,'R','uint8'); %write an 'R' to the Arduino, thereby requesting that the Arduino send over another data packet to MATLAB
    
   
    t = [t,now_t+handle_i * 0.25]; %sec

    
    %plot the channel value
    plot_handles(handle_i,1) = plot(handles.PPM_plot,t,x,'b');  
    %increment handle index, and roll it over if necessary
    handle_i = handle_i + 1;
    
    drawnow; %force the plot to redraw
    %pause(.05); %wait a bit before requesting more data from the Arduino
    pause(.25);
end

plot_handles(handle_i,1) = plot(handles.PPM_plot,[t(length(t))],[3],'r<', 'MarkerSize',15);

now_t = t(length(t));
last_toc = toc;
%data_str = sprintf('AverageValue=%.2f\nMinimumValue=%4d\nMaximumValue=%4d\n',mean(x), min(x), max(x));
%set(handles.text_output,'String',data_str);
data_time = t';
data_voltage = x';
save(file_name, 'data_time', 'data_voltage');%save the datalogging file



