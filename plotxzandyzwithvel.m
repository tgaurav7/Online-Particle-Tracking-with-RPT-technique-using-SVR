function varargout = plotxyinzrange(varargin)
% PLOTXYINZRANGE MATLAB code for plotxyinzrange.fig
%      PLOTXYINZRANGE, by itself, creates a new PLOTXYINZRANGE or raises the existing
%      singleton*.
%
%      H = PLOTXYINZRANGE returns the handle to a new PLOTXYINZRANGE or the handle to
%      the existing singleton*.
%
%      PLOTXYINZRANGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLOTXYINZRANGE.M with the given input arguments.
%
%      PLOTXYINZRANGE('Property','Value',...) creates a new PLOTXYINZRANGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before plotxyinzrange_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to plotxyinzrange_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help plotxyinzrange

% Last Modified by GUIDE v2.5 19-Jul-2015 18:14:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @plotxyinzrange_OpeningFcn, ...
                   'gui_OutputFcn',  @plotxyinzrange_OutputFcn, ...
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


% --- Executes just before plotxyinzrange is made visible.
function plotxyinzrange_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to plotxyinzrange (see VARARGIN)

% Choose default command line output for plotxyinzrange
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes plotxyinzrange wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = plotxyinzrange_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function zmin_Callback(hObject, eventdata, handles)
% hObject    handle to zmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zmin as text
%        str2double(get(hObject,'String')) returns contents of zmin as a double


% --- Executes during object creation, after setting all properties.
function zmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zmax_Callback(hObject, eventdata, handles)
% hObject    handle to zmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zmax as text
%        str2double(get(hObject,'String')) returns contents of zmax as a double


% --- Executes during object creation, after setting all properties.
function zmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plotxy.
function plotxy_Callback(hObject, eventdata, handles)
% hObject    handle to plotxy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data_X = load('exp_results_x.txt');
data_Y = load('exp_results_y.txt');
data_Z = load('exp_results_z.txt');
zmin = str2num(get(handles.zmin, 'string'))
zmax = str2num(get(handles.zmax, 'string'))
arrx = [];
arry = [];
for i = 1:length(data_Z)
    if((data_Z(i)>zmin)&&(data_Z(i)<=zmax))
        arrx = [arrx data_X(i)];
        arry = [arry data_Y(i)];
    end
end

 disp('plotting in z range')
  axes(handles.axesxy)
  h = plot(arrx, arry, 'b.');
  legend('Y vs X');
  x1 = max([arrx]);
  x2 = min([arrx]);
  y1 = max([arry]);
  y2 = min([arry]);
  axis([x2 x1 y2 y1]);
  

function tmin_Callback(hObject, eventdata, handles)
% hObject    handle to tmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tmin as text
%        str2double(get(hObject,'String')) returns contents of tmin as a double


% --- Executes during object creation, after setting all properties.
function tmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tmax_Callback(hObject, eventdata, handles)
% hObject    handle to tmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tmax as text
%        str2double(get(hObject,'String')) returns contents of tmax as a double


% --- Executes during object creation, after setting all properties.
function tmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plotztrack.
function plotztrack_Callback(hObject, eventdata, handles)
% hObject    handle to plotztrack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global arx
global ary
global arz
data_X = load('exp_results_x.txt');
data_Y = load('exp_results_y.txt');
data_Z = load('exp_results_z.txt');
tmin = str2num(get(handles.tmin, 'string'));
tmax = str2num(get(handles.tmax, 'string'));
arx = [];
ary = [];
arz = [];
time = 0;
tim = [];
for i = 1:length(data_Z)
    if((time>tmin)&&(time<=tmax))
        arx = [arx data_X(i)];
        ary = [ary data_Y(i)];
        arz = [arz data_Z(i)];
        tim = [tim time];
    end
    time = time + 0.02;
end
 disp('plotting in time range')
  axes(handles.axesxtrack)
  h = plot(tim, arx, ' -');
  legend('X vs Time');
  x1 = max([arx]);
  x2 = min([arx]);
  axis([tim(1) tim(length(tim)) x2 x1]);
  
  disp('plotting in time range')
  axes(handles.axesytrack)
  h = plot(tim, ary, ' -');
  legend('Y vs Time');
  y1 = max([ary]);
  y2 = min([ary]);
  axis([tim(1) tim(length(tim)) y2 y1]);
  
  disp('plotting in time range')
  axes(handles.axesztrack)
  h = plot(tim, arz, ' -');
  legend('Z vs Time');
  z1 = max([arz]);
  z2 = min([arz]);
  axis([tim(1) tim(length(tim)) z2 z1]);

% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
global arx
global ary
global arz
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmin = str2num(get(handles.tmin, 'string'));
tmax = str2num(get(handles.tmax, 'string'));
fnamex = sprintf('x_positions_%d_to_%d.txt', tmin, tmax);
fileID = fopen(fnamex,'w');
fprintf(fileID, '%f\n', arx);
fclose(fileID);
fnamey = sprintf('y_positions_%d_to_%d.txt', tmin, tmax);
fileID = fopen(fnamey,'w');
fprintf(fileID, '%f\n', ary);
fclose(fileID);
disp('writing in time range')
fnamez = sprintf('z_positions_%d_to_%d.txt', tmin, tmax);
fileID = fopen(fnamez,'w');
fprintf(fileID, '%f\n', arz);
fclose(fileID);