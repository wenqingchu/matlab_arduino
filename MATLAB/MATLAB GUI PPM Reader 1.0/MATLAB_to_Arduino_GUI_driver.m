
function varargout = MATLAB_to_Arduino_GUI_driver(varargin)


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MATLAB_to_Arduino_GUI_driver_OpeningFcn, ...
                   'gui_OutputFcn',  @MATLAB_to_Arduino_GUI_driver_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before MATLAB_to_Arduino_GUI_driver is made visible.
function MATLAB_to_Arduino_GUI_driver_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MATLAB_to_Arduino_GUI_driver (see VARARGIN)

% Choose default command line output for MATLAB_to_Arduino_GUI_driver
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MATLAB_to_Arduino_GUI_driver wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MATLAB_to_Arduino_GUI_driver_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in start_btn.
function start_btn_Callback(hObject, eventdata, handles)
% hObject    handle to start_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%% My Code Begins Here %%%
clc; %clear the screen

%clear the plot, in case anything remains from prev. run
cla(handles.PPM_plot,'reset');

%initialize some values for teh stop button
stop_btn_data.stop = false; %set stop = false since the button has NOT yet been pressed
set(handles.stop_btn,'UserData',stop_btn_data) %store the stop_btn_data into UserData
set(handles.text_output,'String','Data Output') %clear the output text string

%since the button has been pushed, make it red and have the words "running" on it now
start_btn_data.color = get(handles.start_btn,'BackgroundColor'); %copy the initial color value
set(handles.start_btn,'UserData',start_btn_data); %store the color value before losing it
set(handles.start_btn,'BackgroundColor',[1 .5 .5]); %make the start_btn light red
set(handles.start_btn,'String','Running','Enable','off'); %make it change text to "Running", and disable the button
set(handles.stop_btn,'Enable','on'); %enable the stop button
set(handles.serial_info,'String','Connecting to the Arduino...');
drawnow; %force button state to visually update

%Call the main code script (m-file)
MATLAB_to_Arduino



% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over start_btn.
function start_btn_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to start_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in stop_btn.
function stop_btn_Callback(hObject, eventdata, handles)
% hObject    handle to stop_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

stop_btn_data.stop = true; %set stop = true since the button has been pressed
set(handles.stop_btn,'UserData',stop_btn_data) %store the stop_btn_data into UserData

%turn the start button back to normal, re-enabling it, while disabling the stop button
start_btn_data = get(handles.start_btn,'UserData');
set(handles.start_btn,'BackgroundColor',start_btn_data.color);
set(handles.start_btn,'String','Start','Enable','on');
set(handles.stop_btn,'Enable','off');

pushbutton5_data = get(handles.start_btn,'UserData');
set(handles.pushbutton5,'BackgroundColor',pushbutton5_data.color);
set(handles.pushbutton5,'String','Continue','Enable','on');

drawnow; %force button redraw


% --- Executes during object creation, after setting all properties.
function text_output_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function com_port_Callback(hObject, eventdata, handles)
% hObject    handle to com_port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of com_port as text
%        str2double(get(hObject,'String')) returns contents of com_port as a double


% --- Executes during object creation, after setting all properties.
function com_port_CreateFcn(hObject, eventdata, handles)
% hObject    handle to com_port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function start_time_Callback(hObject, eventdata, handles)
% hObject    handle to start_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of start_time as text
%        str2double(get(hObject,'String')) returns contents of start_time as a double


% --- Executes during object creation, after setting all properties.
function start_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to start_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function end_time_Callback(hObject, eventdata, handles)
% hObject    handle to end_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of end_time as text
%        str2double(get(hObject,'String')) returns contents of end_time as a double


% --- Executes during object creation, after setting all properties.
function end_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to end_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x;
global t;
start_time = get(handles.start_time,'String');
start_time = 4*(str2num(start_time)-t(1));
end_time = get(handles.end_time,'String');
end_time = 4*(str2num(end_time)-t(1));
ll = length(x);
if ((start_time > 0) && (end_time < ll)) && (start_time < end_time)
            temp_x = x(start_time:end_time);
    data_str = sprintf('Average   Value=%.2f\nMinimum  Value=%4d\nMaximum  Value=%4d\n',mean(temp_x), min(temp_x), max(temp_x));
else
    data_str = sprintf('illegal time input!\n please check again!');
end

set(handles.text_output,'String',data_str);


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%initialize some values for teh stop button

global x;
global t;

stop_btn_data.stop = false; %set stop = false since the button has NOT yet been pressed
set(handles.stop_btn,'UserData',stop_btn_data) %store the stop_btn_data into UserData
set(handles.text_output,'String','Data Output') %clear the output text string


set(handles.start_btn,'String','Start','Enable','off');


%since the button has been pushed, make it red and have the words "running" on it now
pushbutton5_data.color = get(handles.pushbutton5,'BackgroundColor'); %copy the initial color value
set(handles.pushbutton5,'UserData',pushbutton5_data); %store the color value before losing it
set(handles.pushbutton5,'BackgroundColor',[1 .5 .5]); %make the start_btn light red
set(handles.pushbutton5,'String','Running','Enable','off'); %make it change text to "Running", and disable the button
set(handles.stop_btn,'Enable','on'); %enable the stop button
set(handles.serial_info,'String','Continue...');
drawnow; %force button state to visually update

%Call the main code script (m-file)
MATLAB_to_Arduino_continue
