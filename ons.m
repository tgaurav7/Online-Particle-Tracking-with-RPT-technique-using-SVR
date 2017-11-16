function varargout = ons(varargin)
% ONS MATLAB code for ons.fig
%      ONS, by itself, creates a new ONS or raises the existing
%      singleton*.
%
%      H = ONS returns the handle to a new ONS or the handle to
%      the existing singleton*.
%
%      ONS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ONS.M with the given input arguments.
%
%      ONS('Property','Value',...) creates a new ONS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ons_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ons_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ons

% Last Modified by GUIDE v2.5 24-Oct-2017 00:38:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ons_OpeningFcn, ...
                   'gui_OutputFcn',  @ons_OutputFcn, ...
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


global model
% --- Executes just before ons is made visible.
function ons_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ons (see VARARGIN)

% Choose default command line output for ons
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ons wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ons_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Train.
function Train_Callback(hObject, eventdata, handles)
% hObject    handle to Train (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath ('C:\libsvm-3.17\libsvm-3.17\matlab')
global modelx
global modely 
global modelz
trn_data.X = load('trn_data.txt');
trn_data.y = load('trn_x.txt');

tst_data.X = load('tst_data.txt');
tst_data.y = load('tst_x.txt');


%%h = findobj('Tag', 'epsilonValx');
%%e = get(h, 'UserData');
ex = str2num(get(handles.epsilonValx, 'string'));

%%parentfig = get(hObject, 'Parent');
%%e = getappdata(parentfig, 'epsilon');

%%display(e);
%length(tst_data.X)
%length(tst_data.y)



[trn_data, tst_data, jn2] = scaleSVM(trn_data, tst_data, trn_data, 0, 1);



% tst_data.y;
param.s = 3; 					% epsilon SVR
% param.C = 1;
param.Cset = 2.^[7:9];	% FIX C based on Equation 9.61
param.t = 2; 					% RBF kernel
param.gset = 2.^[-7:7];				% range of the gamma parameter
param.e = ex;				% range of the epsilon parameter
param.nfold = 5;				% 5-fold CV

Rval = zeros(length(param.gset), length(param.Cset));
for i = 1:param.nfold
    % partition the training data into the learning/validation
    % in this example, the 5-fold data partitioning is done by the following strategy,
    % for partition 1: Use samples 1, 6, 11, ... as validation samples and
    %			the remaining as learning samples
    % for partition 2: Use samples 2, 7, 12, ... as validation samples and
    %			the remaining as learning samples
    %   :
    % for partition 5: Use samples 5, 10, 15, ... as validation samples and
    %			the remaining as learning samples

    data = [trn_data.y, trn_data.X];
    [learn, val] = k_FoldCV_SPLIT(data, param.nfold, i);
    lrndata.X = learn(:, 2:end);
    lrndata.y = learn(:, 1);
    valdata.X = val(:, 2:end);
    valdata.y = val(:, 1);

    for j = 1:length(param.gset)
        param.g = param.gset(j);

        for k = 1:length(param.Cset)
            param.C = param.Cset(k);
            param.libsvm = ['-q -s ', num2str(param.s), ' -t ', num2str(param.t), ...
                    ' -c ', num2str(param.C), ' -g ', num2str(param.g), ...
                    ' -p ', num2str(param.e)];

            % build model on Learning data
            modelx = svmtrain(lrndata.y, lrndata.X, param.libsvm);

            % predict on the validation data
            [y_hat, Acc, projection] = svmpredict(valdata.y, valdata.X, modelx);

            Rval(j,k) = Rval(j,k) + mean((y_hat-valdata.y).^2);
        end
    end

end
Rval = Rval ./ (param.nfold);

[v1, i1] = min(Rval);
[v2, i2] = min(v1);
optparam = param;
optparam.g = param.gset( i1(i2) );
optparam.C = param.Cset(i2);

%{
optparam = param;
optparam.g = 0.125;
optparam.e = 0.01;
%}

optparam.libsvm = ['-q -s ', num2str(optparam.s), ' -t ', num2str(optparam.t), ...
        ' -c ', num2str(optparam.C), ' -g ', num2str(optparam.g), ...
        ' -p ', num2str(optparam.e)];

modelx = svmtrain(trn_data.y, trn_data.X, optparam.libsvm);

% MSE for test samples
[y_hat, AccTest, projection] = svmpredict(tst_data.y, tst_data.X, modelx);
MSE_Test = mean((y_hat-tst_data.y).^2);
NRMS_Test = sqrt(MSE_Test) / std(tst_data.y);

%for i=1:size(tst_data.y,1)
%    disp([num2str(y_hat(i)) '       ' num2str(tst_data.y(i))]);
%end

%{
% MSE for training samples
[y_hat, AccTrain, projection] = svmpredict(trn_data.y, trn_data.X, model);
MSE_Train = mean((y_hat-trn_data.y).^2);
NRMS_Train = sqrt(MSE_Train) / std(trn_data.y);

%}

%trn_data.y

disp( ['C= ' num2str(optparam.C) 'Gamma = ' num2str(optparam.g) 'Epsilon= ' num2str(optparam.e)]);
modelx
set(handles.gammaValx, 'string', num2str(optparam.g));
set(handles.cValx, 'string', num2str(optparam.C));
set(handles.epsilonValx, 'string', num2str(optparam.e));

trn_data.X = load('trn_data.txt');
trn_data.y = load('trn_y.txt');

tst_data.X = load('tst_data.txt');
tst_data.y = load('tst_y.txt');


%%h = findobj('Tag', 'epsilonValx');
%%e = get(h, 'UserData');
ey = str2num(get(handles.epsilonValx, 'string'));

%%parentfig = get(hObject, 'Parent');
%%e = getappdata(parentfig, 'epsilon');

%%display(e);
%length(tst_data.X)
%length(tst_data.y)



[trn_data, tst_data, jn2] = scaleSVM(trn_data, tst_data, trn_data, 0, 1);



% tst_data.y;
param.s = 3; 					% epsilon SVR
% param.C = 1;
param.Cset = 2.^[7:9];	% FIX C based on Equation 9.61
param.t = 2; 					% RBF kernel
param.gset = 2.^[-7:7];				% range of the gamma parameter
param.e = ey;				% range of the epsilon parameter
param.nfold = 5;				% 5-fold CV

Rval = zeros(length(param.gset), length(param.Cset));
for i = 1:param.nfold
    % partition the training data into the learning/validation
    % in this example, the 5-fold data partitioning is done by the following strategy,
    % for partition 1: Use samples 1, 6, 11, ... as validation samples and
    %			the remaining as learning samples
    % for partition 2: Use samples 2, 7, 12, ... as validation samples and
    %			the remaining as learning samples
    %   :
    % for partition 5: Use samples 5, 10, 15, ... as validation samples and
    %			the remaining as learning samples

    data = [trn_data.y, trn_data.X];
    [learn, val] = k_FoldCV_SPLIT(data, param.nfold, i);
    lrndata.X = learn(:, 2:end);
    lrndata.y = learn(:, 1);
    valdata.X = val(:, 2:end);
    valdata.y = val(:, 1);

    for j = 1:length(param.gset)
        param.g = param.gset(j);

        for k = 1:length(param.Cset)
            param.C = param.Cset(k);
            param.libsvm = ['-q -s ', num2str(param.s), ' -t ', num2str(param.t), ...
                    ' -c ', num2str(param.C), ' -g ', num2str(param.g), ...
                    ' -p ', num2str(param.e)];

            % build model on Learning data
            modely = svmtrain(lrndata.y, lrndata.X, param.libsvm);

            % predict on the validation data
            [y_hat, Acc, projection] = svmpredict(valdata.y, valdata.X, modely);

            Rval(j,k) = Rval(j,k) + mean((y_hat-valdata.y).^2);
        end
    end

end
Rval = Rval ./ (param.nfold);

[v1, i1] = min(Rval);
[v2, i2] = min(v1);
optparam = param;
optparam.g = param.gset( i1(i2) );
optparam.C = param.Cset(i2);

%{
optparam = param;
optparam.g = 0.125;
optparam.e = 0.01;
%}

optparam.libsvm = ['-q -s ', num2str(optparam.s), ' -t ', num2str(optparam.t), ...
        ' -c ', num2str(optparam.C), ' -g ', num2str(optparam.g), ...
        ' -p ', num2str(optparam.e)];

modely = svmtrain(trn_data.y, trn_data.X, optparam.libsvm);

% MSE for test samples
[y_hat, AccTest, projection] = svmpredict(tst_data.y, tst_data.X, modely);
MSE_Test = mean((y_hat-tst_data.y).^2);
NRMS_Test = sqrt(MSE_Test) / std(tst_data.y);

%for i=1:size(tst_data.y,1)
%    disp([num2str(y_hat(i)) '       ' num2str(tst_data.y(i))]);
%end

%{
% MSE for training samples
[y_hat, AccTrain, projection] = svmpredict(trn_data.y, trn_data.X, model);
MSE_Train = mean((y_hat-trn_data.y).^2);
NRMS_Train = sqrt(MSE_Train) / std(trn_data.y);

%}

%trn_data.y

disp( ['C= ' num2str(optparam.C) 'Gamma = ' num2str(optparam.g) 'Epsilon= ' num2str(optparam.e)]);
modely
set(handles.gammaValy, 'string', num2str(optparam.g));
set(handles.cValy, 'string', num2str(optparam.C));
set(handles.epsilonValy, 'string', num2str(optparam.e));



trn_data.X = load('trn_data.txt');
trn_data.y = load('trn_z.txt');

tst_data.X = load('tst_data.txt');
tst_data.y = load('tst_z.txt');


%%h = findobj('Tag', 'epsilonValx');
%%e = get(h, 'UserData');
ez = str2num(get(handles.epsilonValz, 'string'));

%%parentfig = get(hObject, 'Parent');
%%e = getappdata(parentfig, 'epsilon');

%%display(e);
%length(tst_data.X)
%length(tst_data.y)



[trn_data, tst_data, jn2] = scaleSVM(trn_data, tst_data, trn_data, 0, 1);



% tst_data.y;
param.s = 3; 					% epsilon SVR
% param.C = 1;
param.Cset = 2.^[7:9];	% FIX C based on Equation 9.61
param.t = 2; 					% RBF kernel
param.gset = 2.^[-7:7];				% range of the gamma parameter
param.e = ez;				% range of the epsilon parameter
param.nfold = 5;				% 5-fold CV

Rval = zeros(length(param.gset), length(param.Cset));
for i = 1:param.nfold
    % partition the training data into the learning/validation
    % in this example, the 5-fold data partitioning is done by the following strategy,
    % for partition 1: Use samples 1, 6, 11, ... as validation samples and
    %			the remaining as learning samples
    % for partition 2: Use samples 2, 7, 12, ... as validation samples and
    %			the remaining as learning samples
    %   :
    % for partition 5: Use samples 5, 10, 15, ... as validation samples and
    %			the remaining as learning samples

    data = [trn_data.y, trn_data.X];
    [learn, val] = k_FoldCV_SPLIT(data, param.nfold, i);
    lrndata.X = learn(:, 2:end);
    lrndata.y = learn(:, 1);
    valdata.X = val(:, 2:end);
    valdata.y = val(:, 1);

    for j = 1:length(param.gset)
        param.g = param.gset(j);

        for k = 1:length(param.Cset)
            param.C = param.Cset(k);
            param.libsvm = ['-q -s ', num2str(param.s), ' -t ', num2str(param.t), ...
                    ' -c ', num2str(param.C), ' -g ', num2str(param.g), ...
                    ' -p ', num2str(param.e)];

            % build model on Learning data
            modelz = svmtrain(lrndata.y, lrndata.X, param.libsvm);

            % predict on the validation data
            [y_hat, Acc, projection] = svmpredict(valdata.y, valdata.X, modelz);

            Rval(j,k) = Rval(j,k) + mean((y_hat-valdata.y).^2);
        end
    end

end
Rval = Rval ./ (param.nfold);

[v1, i1] = min(Rval);
[v2, i2] = min(v1);
optparam = param;
optparam.g = param.gset( i1(i2) );
optparam.C = param.Cset(i2);

%{
optparam = param;
optparam.g = 0.125;
optparam.e = 0.01;
%}

optparam.libsvm = ['-q -s ', num2str(optparam.s), ' -t ', num2str(optparam.t), ...
        ' -c ', num2str(optparam.C), ' -g ', num2str(optparam.g), ...
        ' -p ', num2str(optparam.e)];

modelz = svmtrain(trn_data.y, trn_data.X, optparam.libsvm);

% MSE for test samples
[y_hat, AccTest, projection] = svmpredict(tst_data.y, tst_data.X, modelz);
MSE_Test = mean((y_hat-tst_data.y).^2);
NRMS_Test = sqrt(MSE_Test) / std(tst_data.y);

%for i=1:size(tst_data.y,1)
%    disp([num2str(y_hat(i)) '       ' num2str(tst_data.y(i))]);
%end

%{
% MSE for training samples
[y_hat, AccTrain, projection] = svmpredict(trn_data.y, trn_data.X, model);
MSE_Train = mean((y_hat-trn_data.y).^2);
NRMS_Train = sqrt(MSE_Train) / std(trn_data.y);

%}

%trn_data.y

disp( ['C= ' num2str(optparam.C) 'Gamma = ' num2str(optparam.g) 'Epsilon= ' num2str(optparam.e)]);
modelz
set(handles.gammaValz, 'string', num2str(optparam.g));
set(handles.cValz, 'string', num2str(optparam.C));
set(handles.epsilonValz, 'string', num2str(optparam.e));


%%testVariable(model);



% --- Executes on button press in Reconstruct.
function Reconstruct_Callback(hObject, eventdata, handles)
% hObject    handle to Reconstruct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global xval
global yval
global zval
nor = str2num(get(handles.nor, 'string'));
nof = str2num(get(handles.nof, 'string'));
num = 0;
time = nor*(nof+2)*0.02;
pausetime = nor*0.02;
t = timer('TimerFcn', 'stat=false; ',... 
                 'StartDelay',time);
start(t)

stat=true;
while(stat==true&&num<nof)
    num = num + 1;
    
  %disp('testVariablex')
  axes(handles.axesx)
  %plot(sin(0:0.1:i))
  testVariablex(num);
 % disp('testVariabley')
  axes(handles.axesy)
  %plot(cos(0:0.1:i))
  testVariabley(num);
  %disp('testVariablez')
  axes(handles.axesz)
  %plot(tan(0:0.1:i))
  testVariablez(num);
  %disp('testVariablexz')
  axes(handles.axesxz)
  h = plot(xval, zval, ' -');
  legend('Z vs X');
  x1 = max([xval]);
  x2 = min([xval]);
  z1 = max([zval]);
  z2 = min([zval]);
  axis([x2 x1 z2 z1]);
  %disp('testVariablexy')
  axes(handles.axesxy)
  h = plot(xval, yval, ' -');
  legend('Y vs X');
  x1 = max([xval]);
  x2 = min([xval]);
  y1 = max([yval]);
  y2 = min([yval]);
  axis([x2 x1 y2 y1]);
  pause(pausetime)
end


% --- Executes on button press in PLot.
function PLot_Callback(hObject, eventdata, handles)
% hObject    handle to PLot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function epsilonValx_Callback(hObject, eventdata, handles)
% hObject    handle to epsilonValx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of epsilonValx as text
%        str2double(get(hObject,'String')) returns contents of epsilonValx as a double


% --- Executes during object creation, after setting all properties.
function epsilonValx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epsilonValx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gammaValx_Callback(hObject, eventdata, handles)
% hObject    handle to gammaValx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gammaValx as text
%        str2double(get(hObject,'String')) returns contents of gammaValx as a double


% --- Executes during object creation, after setting all properties.
function gammaValx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gammaValx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cValx_Callback(hObject, eventdata, handles)
% hObject    handle to cValx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cValx as text
%        str2double(get(hObject,'String')) returns contents of cValx as a double


% --- Executes during object creation, after setting all properties.
function cValx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cValx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nor_Callback(hObject, eventdata, handles)
% hObject    handle to nor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nor as text
%        str2double(get(hObject,'String')) returns contents of nor as a double


% --- Executes during object creation, after setting all properties.
function nor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nof_Callback(hObject, eventdata, handles)
% hObject    handle to nof (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nof as text
%        str2double(get(hObject,'String')) returns contents of nof as a double


% --- Executes during object creation, after setting all properties.
function nof_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nof (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function epsilonValy_Callback(hObject, eventdata, handles)
% hObject    handle to epsilonValy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of epsilonValy as text
%        str2double(get(hObject,'String')) returns contents of epsilonValy as a double


% --- Executes during object creation, after setting all properties.
function epsilonValy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epsilonValy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gammaValy_Callback(hObject, eventdata, handles)
% hObject    handle to gammaValy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gammaValy as text
%        str2double(get(hObject,'String')) returns contents of gammaValy as a double


% --- Executes during object creation, after setting all properties.
function gammaValy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gammaValy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cValy_Callback(hObject, eventdata, handles)
% hObject    handle to cValy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cValy as text
%        str2double(get(hObject,'String')) returns contents of cValy as a double


% --- Executes during object creation, after setting all properties.
function cValy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cValy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function epsilonValz_Callback(hObject, eventdata, handles)
% hObject    handle to epsilonValz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of epsilonValz as text
%        str2double(get(hObject,'String')) returns contents of epsilonValz as a double


% --- Executes during object creation, after setting all properties.
function epsilonValz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epsilonValz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gammaValz_Callback(hObject, eventdata, handles)
% hObject    handle to gammaValz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gammaValz as text
%        str2double(get(hObject,'String')) returns contents of gammaValz as a double


% --- Executes during object creation, after setting all properties.
function gammaValz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gammaValz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cValz_Callback(hObject, eventdata, handles)
% hObject    handle to cValz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cValz as text
%        str2double(get(hObject,'String')) returns contents of cValz as a double


% --- Executes during object creation, after setting all properties.
function cValz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cValz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plot.
function plot_Callback(hObject, eventdata, handles)
% hObject    handle to plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plotxyinzrange();
