function varargout = points(varargin)
% POINTS MATLAB code for points.fig
%      POINTS, by itself, creates a new POINTS or raises the existing
%      singleton*.
%
%      H = POINTS returns the handle to a new POINTS or the handle to
%      the existing singleton*.
%
%      POINTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POINTS.M with the given input arguments.
%
%      POINTS('Property','Value',...) creates a new POINTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before points_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to points_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help points

% Last Modified by GUIDE v2.5 26-Dec-2013 22:20:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @points_OpeningFcn, ...
                   'gui_OutputFcn',  @points_OutputFcn, ...
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


% --- Executes just before points is made visible.
function points_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to points (see VARARGIN)

% Choose default command line output for points
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes points wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = points_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in next.
function next_Callback(hObject, eventdata, handles)
% hObject    handle to next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global index files pathname cell 
index = index + 1;
str = [pathname files(index).name];
im = imread(str);
axes(handles.pics);
imshow(im);
hold on
plotPoints();
hold off
set(handles.picName, 'String', files(index).name);
set(handles.edit2, 'String', cell{2});


% --- Executes on button press in selectPath.
function selectPath_Callback(hObject, eventdata, handles)
% hObject    handle to selectPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global index files pathname cell

[filename,pathname] = ...
    uigetfile({'*.bmp';'*.png'},'请选择文件夹中的第一张图片');
index = 1;
files = dir(fullfile(pathname, '*.bmp'));

% 在pics控件中显示读取到的第一张图片
str = [pathname filename];
im = imread(str);
axes(handles.pics);
imshow(im);
hold on
plotPoints();
hold off
        
set(handles.edit2, 'String', cell{2});
set(handles.picName, 'String', files(index).name);


function plotPoints(hObject, eventdata, handles)
global x y z pathname index cell % startLine 
fi = fopen([pathname,'3Ddata.txt'],'rt','n','utf-8');
nline =0;
startLine = (index - 1) * 121;
endLine = index * 121;
while(nline < endLine)
    tline = fgetl(fi);               % 获取一行信息
    nline = nline + 1;               
    if(nline > startLine)
        data = tline(25:length(tline));
        cell = regexp(data, '\s+', 'split');
        cell(cellfun('isempty', cell)) = [];
        % z为该点的实际距离
        z = str2double(cell{4});
        % x,y为投影至照片的像素值
        x = 320 + (0.95 / z) * str2double(cell{2}) * 320 / (z * tan(28.5 * pi / 180));
        y = 250 - (0.95 / z) * str2double(cell{3}) * 240 / (z * tan(21.5 * pi / 180));        
        plot(x, y, 'r');
    end    
end


function picName_Callback(hObject, eventdata, handles)
% hObject    handle to picName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of picName as text
%        str2double(get(hObject,'String')) returns contents of picName as a double


% --- Executes during object creation, after setting all properties.
function picName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to picName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in last.
function last_Callback(hObject, eventdata, handles)
% hObject    handle to last (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global index files pathname cell
index = index - 1;
str = [pathname files(index).name];
im = imread(str);
axes(handles.pics);
imshow(im);
hold on
plotPoints();
hold off

set(handles.picName, 'String', files(index).name);
set(handles.edit2, 'String', cell{2});



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
