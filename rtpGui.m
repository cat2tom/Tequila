function varargout = rtpGui(varargin)
% RTPGUI MATLAB code for rtpGui.fig
%      RTPGUI, by itself, creates a new RTPGUI or raises the existing
%      singleton*.
%
%      H = RTPGUI returns the handle to a new RTPGUI or the handle to
%      the existing singleton*.
%
%      RTPGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RTPGUI.M with the given input arguments.
%
%      RTPGUI('Property','Value',...) creates a new RTPGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before rtpGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to rtpGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help rtpGui

% Last Modified by GUIDE v2.5 12-Dec-2015 20:05:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @rtpGui_OpeningFcn, ...
    'gui_OutputFcn',  @rtpGui_OutputFcn, ...
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

% --- Executes just before rtpGui is made visible.
function rtpGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to rtpGui (see VARARGIN)

% Choose default command line output for rtpGui
handles.output = hObject;

%
clearPlan_Callback(hObject, eventdata, handles)
handles.TablesTMR = [];
handles.TablesFSY = [];
handles.TablesWF = [];

%
set(hObject,'name','TeXla v1.0');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes rtpGui wait for user response (see UIRESUME)
% uiwait(handles.rtpGui);

% --- Outputs from this function are returned to the command line.
function varargout = rtpGui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --------------- my auxiliar functions --------------
function rtpDisplay(handles)

% homemade display
axes(handles.rtpView);
imagesc(handles.Grid.grid);
[N, M] = size(handles.Grid.grid);
hold on;
line([1:N],M/2*ones(1,N),'Color',[1 0 0]);
line(N/2*ones(1,M),[1:M],'Color',[1 0 0]);
hold off;

colormap(bone);
title('Te\chila');
xlabel(colorbar,'Intensity (HU)');
if (get(handles.showAxis,'Value'))
    axis on;
else
    axis off;
end

%
set(handles.dref,'String','');
set(handles.Dcal,'String','');

function rtpOverlayDisplay (handles)


% plan
imgPlan = handles.Plan;  % Gy

% mask of marked region
bd = handles.Grid.bound;
imgMask = im2bw(handles.DoseMask);
imgPlan(bd(1):bd(2)-1, bd(3):bd(4)-1) = imgPlan(bd(1):bd(2)-1, bd(3):bd(4)-1) .* imgMask;

% target
imgTarget = mat2gray(handles.Grid.grid) *  max(max(imgPlan));

% homemade display
axes(handles.rtpView);

% show target
imagesc(imgTarget); colormap(bone); freezeColors;

% start
hold on;

% show plan
%h = imagesc(imgPlan); colormap(jet);

% transparency
%tMap = rtpTransparency(handles.Grid.grid, 450, 0.55);

% display
%set(h, 'AlphaData', tMap);

% contour of isodose
contour(imgPlan, 7), colormap(jet);

% finish
hold off;

% labels
%title(sprintf('Te\\chila | d_{ref}=%.1fcm D_{cal}=%.3fGy',handles.D.dref, handles.D.dose));
title(sprintf('Te\\chila'));
xlabel(colorbar,'%');

if (get(handles.showAxis,'Value'))
    axis on;
else
    axis off;
end

% disp
set(handles.dref,'String',sprintf('dref:%.1fcm',handles.D.dref));
set(handles.Dcal,'String',sprintf('Dcal:%.3fGy/MU',handles.D.dose));
% --------------- my auxiliar functions --------------

% --- Executes on button press in clearPlan.
function clearPlan_Callback(hObject, eventdata, handles)
% hObject    handle to clearPlan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.DoseMask = [];
handles.TablesTMR = [];
handles.TablesFSY = [];
handles.TablesWF = [];
handles.phantomSlices = [];
handles.NotPhantom = [];
handles.Phantom = [];
handles.Grid = [];
handles.D = [];
handles.Beam = [];
handles.Vectors = [];
handles.Plan = [];
handles.MU = [];
handles.Wedge =[];

set(handles.isIsoBeam,'BackgroundColor',[1 0 0]);
set(handles.isPlan,'BackgroundColor',[1 0 0]);
set(handles.isWedge,'BackgroundColor',[1 0 0]);
set(handles.isTarget,'BackgroundColor',[1 0 0]);
set(handles.isFSY,'BackgroundColor',[1 0 0]);
set(handles.isWF,'BackgroundColor',[1 0 0]);
set(handles.isTMR,'BackgroundColor',[1 0 0]);

set(handles.dref,'String','');
set(handles.Dcal,'String','');

axes(handles.rtpView);
imshow(zeros(512));

guidata(hObject, handles);

% --------------------------------------------------------------------
function toolDoseDeliver_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toolDoseDeliver (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% choose slice
nSlice = round(get(handles.slicesSlider,'Value'));
Phantom = handles.phantomSlices(:, :, nSlice);

handles.DoseMask = rtpTargetDose(Phantom);
%figure, imagesc(handles.DoseMask * str2double(get(handles.setDose,'String'))), xlabel(colorbar,'Gy');
%

guidata(hObject, handles);

% --------------------------------------------------------------------
function toolBoxCut_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toolBoxCut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get the x and y corner coordinates as integers

% choose slice
nSlice = round(get(handles.slicesSlider,'Value'));
Phantom = handles.phantomSlices(:, :, nSlice);

boxMask = rtpTargetBox(Phantom);
notBoxMask = ~boxMask;

Phantom = Phantom .* boxMask;
NotPhantom = Phantom .* notBoxMask;

% generate grid
% phantom at grid
posCenter = [0, 0];

Grid = rtpGrid(Phantom, posCenter);

% save user data
handles.NotPhantom = NotPhantom;
handles.Phantom = Phantom;
handles.Grid = Grid;
guidata(hObject, handles);

% display
rtpDisplay(handles);



% save box
guidata(hObject, handles);

%
rtpDisplay(handles);

% --- Executes on button press in setBeams.
function setBeams_Callback(hObject, eventdata, handles)
% hObject    handle to setBeams (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of setBeams as text
%        str2double(get(hObject,'String')) returns contents of setBeams as a double

% --- Executes during object creation, after setting all properties.
function setBeams_CreateFcn(hObject, eventdata, handles)
% hObject    handle to setBeams (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in setAngles.
function setAngles_Callback(hObject, eventdata, handles)
% hObject    handle to setAngles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% axes
axes(handles.rtpView);

% from gui
nBeams = str2double(get(handles.setBeams,'String'));

% generate vectors
Vectors = rtpVectors(nBeams);

% save to user interface
handles.Vectors = Vectors;
guidata(hObject, handles);

%
set(handles.isPlan,'BackgroundColor',[0 1 0]);

% --- Executes on button press in setAuto.
function setAuto_Callback(hObject, eventdata, handles)
% hObject    handle to setAuto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

prompt = {'Number of beams:';'Angle multiple:';'Weight multiplier:'};
dlg_title = 'Vectors';
num_lines = 1;
defaultans = {'3','120','1'};
answer = inputdlg(prompt, ...
    dlg_title, ...
    num_lines, ...
    defaultans);

nBeams = round(str2double(answer{1}));          % number of beams
dTheta = round(str2double(answer{2}));          % angles of beams
vWeight = ones(1,nBeams);                       % weight of beams
dWeight = round(str2double(answer{3}));


% simulating planning
for i = 1:nBeams,
    vBeam(i) = dWeight * vWeight(i);
    vAngle(i) = dTheta * (i-1);
    vSizes(i) = 10;
    vWedge(i) = 0;
end


% generate vectors
Vectors = rtpVectors(nBeams, vBeam, vAngle, vSizes, vWedge);

% save to user interface
handles.Vectors = Vectors;

%
guidata(hObject, handles);

%
set(handles.isPlan,'BackgroundColor',[0 1 0]);

% --- Executes on button press in setDose.
function setDose_Callback(hObject, eventdata, handles)
% hObject    handle to setDose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of setBeams as text
%        str2double(get(hObject,'String')) returns contents of setBeams as a double

% --- Executes during object creation, after setting all properties.
function setDose_CreateFcn(hObject, eventdata, handles)
% hObject    handle to setDose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
function barQuality_Callback(hObject, eventdata, handles)
% hObject    handle to barQuality (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function barHelp_Callback(hObject, eventdata, handles)
% hObject    handle to barHelp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function barHelpAbout_Callback(hObject, eventdata, handles)
% hObject    handle to barHelpAbout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
icon = imread('icon.jpg');
h = msgbox(sprintf('Teletherapy Estimator for X-ray Linear Accelerator\nTeXla v1.0\n"We deserve an A+"\nAndré Martins\nDiego Sampaio\nMatheus Silveira\nVinícius Fernando'),'About v1.0','custom',icon);

% --------------------------------------------------------------------
function barTarget_Callback(hObject, eventdata, handles)
% hObject    handle to barTarget (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function barWedge_Callback(hObject, eventdata, handles)
% hObject    handle to barWedge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function barWedgeOpen_Callback(hObject, eventdata, handles)
% hObject    handle to barWedgeOpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% file
[fFile, fPath] = uigetfile('*.txt');

%
[Wedge, Rad] = rtpIsoBeam([fPath, fFile], handles.Grid.size, handles.D); % at dmax

% save user data
%handles.Beam = Beam;
handles.Wedge = Wedge;
%handles.D = D;
guidata(hObject, handles);

%
set(handles.isWedge,'BackgroundColor',[0 1 0]);

% --------------------------------------------------------------------
function barTargetOpen_Callback(hObject, eventdata, handles)
% hObject    handle to barTargetOpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% save full dicom slices in memmory
% ---- RAM LIMITED FUNCTION
% TODO: Resolve to fit memmory
%dicomDir = uigetdir();
%[handles.phantomSlices, handles.phantomInfo, nSlices] = rtpPhantom(dicomDir, 0);
[handles.phantomSlices, handles.phantomInfo, nSlices] = rtpTarget(0);

% choose slice
%nSlice = get(handles.slicesSlider,'Value');
Phantom = handles.phantomSlices(:, :, 1);

% generate first grid
[Hp, Wp] = size(Phantom);
posCenter = [0, 0];               % phantom at grid

Grid = rtpGrid(Phantom, posCenter);

% save user data
handles.DoseMask = ones(Hp, Wp);
handles.NotPhantom = zeros(Hp, Wp);
handles.Phantom = Phantom;
handles.Grid = Grid;
guidata(hObject, handles);

% scrolling
set(handles.slicesSlider,'SliderStep',[(1/(nSlices-1)) 0]);
set(handles.slicesSlider,'Max', nSlices);
set(handles.slicesSlider,'Min', 1);
set(handles.slicesSlider,'Value', 1);
set(handles.slicesSlider,'Enable','On');

% display
rtpDisplay(handles);

%
set(handles.isTarget,'BackgroundColor',[0 1 0]);

% --------------------------------------------------------------------
function barTargetSamplePhantom_Callback(hObject, eventdata, handles)
% hObject    handle to barTargetSamplePhantom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%
set(handles.slicesSlider,'Value', 1);

% sample phantom
nPhantomPoints = 256;  % phantom size
handles.phantomSlices = rtpSamplePhantom(nPhantomPoints);
Phantom = handles.phantomSlices;

% generate first grid
nGridPoints = 256;  % grid size
posCenter = [0, 0];    % phantom at grid

Grid = rtpGrid(Phantom, posCenter);

% save user data
handles.DoseMask = ones(nGridPoints);
handles.NotPhantom = zeros(nGridPoints);
handles.Phantom = Phantom;
handles.Grid = Grid;
guidata(hObject, handles);

% scrolling
set(handles.slicesSlider,'Enable','Off');

% display
rtpDisplay(handles);

%
set(handles.isTarget,'BackgroundColor',[0 1 0]);

% --------------------------------------------------------------------
function barQualityOpen_Callback(hObject, eventdata, handles)

% hObject    handle to barQualityOpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% file
[fFile, fPath] = uigetfile('*.txt');

%
prompt = {'Reference distance (cm):', 'Reference dose (Gy):'};
dlg_title = 'Vectors';
num_lines = 1;
defaultans = {'2','0.01'};

answer = inputdlg(prompt, ...
    dlg_title, ...
    num_lines, ...
    defaultans);

% dose behavior
D.dref = str2double(answer{1}); % cm
D.dose = str2double(answer{2}); % Gy

%
[Beam, Rad] = rtpIsoBeam([fPath, fFile], handles.Grid.size, D); % at dmax

%
set(handles.radiationType,'String', Rad,'ForegroundColor',[0.5 0 0]);

% save user data
handles.Beam = Beam;
handles.Wedge = [];
handles.D = D;
guidata(hObject, handles);

%
set(handles.isIsoBeam,'BackgroundColor',[0 1 0]);

% --------------------------------------------------------------------
function barQualityOpenSample_Callback(hObject, eventdata, handles)
% hObject    handle to barQualityOpenSample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


nDosePoints = handles.Grid.size;   % size of grid
%mu_a = 1/100;                      % decay constant
mu_a = 0;

% sample beam exponential attenuation
[Beam, Rad] = rtpSampleBeam(nDosePoints, mu_a,'SAMPLE');

%
handles.D.dose = 0.01; % Gy
handles.D.dref = 2; % cm

%
set(handles.radiationType,'String', Rad,'ForegroundColor',[0.5 0 0]);

% save user data
handles.Beam = Beam;
handles.Wedge = [];
guidata(hObject, handles);

%
set(handles.isIsoBeam,'BackgroundColor',[0 1 0]);

% --------------------------------------------------------------------
function barTables_Callback(hObject, eventdata, handles)
% hObject    handle to barTables (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function barTablesLoadFSY_Callback(hObject, eventdata, handles)
% hObject    handle to barTablesLoadFSY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%
[a, b] = uigetfile('*.txt');

handles.TablesFSY = csvread([b,a]);

if (size(handles.TablesFSY, 2) < 4),
    return;
end

%
guidata(hObject, handles);


%
set(handles.isFSY,'BackgroundColor',[0 1 0]);

% --------------------------------------------------------------------
function barTablesLoadTMR_Callback(hObject, eventdata, handles)

%
[a, b] = uigetfile('*.txt');

handles.TablesTMR = csvread([b,a]);

% TODO: Back to cm
handles.TablesTMR(:,1) = handles.TablesTMR(:,1) * 10; % cm to px

%
guidata(hObject, handles);

%
set(handles.isTMR,'BackgroundColor',[0 1 0]);

% --------------------------------------------------------------------
function barTablesLoadWedge_Callback(hObject, eventdata, handles)
% hObject    handle to barTablesLoadWedge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%
[a, b] = uigetfile('*.txt');

handles.TablesWF = csvread([b,a]);

handles.TablesWF(:,1) = handles.TablesWF(:,1) * 10; % cm to px

%
guidata(hObject, handles);

%
set(handles.isWF,'BackgroundColor',[0 1 0]);

% --------------------------------------------------------------------
function barTargetSamples_Callback(hObject, eventdata, handles)
% hObject    handle to barTargetSamples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function barTargetSampleSphere_Callback(hObject, eventdata, handles)
% hObject    handle to barTargetSampleSphere (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%
set(handles.slicesSlider,'Value', 1);

% sample phantom
nPhantomPoints = 256;  % phantom size
handles.phantomSlices = rtpSamplePhantom(nPhantomPoints, 0);
Phantom = handles.phantomSlices;

% generate first grid
nGridPoints = 256;  % grid size
posCenter = [0, 0];    % phantom at grid

Grid = rtpGrid(Phantom, posCenter);

% save user data
handles.DoseMask = ones(nGridPoints);
handles.NotPhantom = zeros(nGridPoints);
handles.Phantom = Phantom;
handles.Grid = Grid;
guidata(hObject, handles);

% scrolling
set(handles.slicesSlider,'Enable','Off');

% display
rtpDisplay(handles);

%
set(handles.isTarget,'BackgroundColor',[0 1 0]);

% --------------------------------------------------------------------
function barTargetSampleSquare_Callback(hObject, eventdata, handles)
% hObject    handle to barTargetSampleSquare (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%
set(handles.slicesSlider,'Value', 1);

% sample phantom
nPhantomPoints = 256;  % phantom size
handles.phantomSlices = rtpSamplePhantom(nPhantomPoints, 1);
Phantom = handles.phantomSlices;

% generate first grid
nGridPoints = 256;  % grid size
posCenter = [0, 0];    % phantom at grid

Grid = rtpGrid(Phantom, posCenter);

% save user data
handles.DoseMask = ones(nGridPoints);
handles.NotPhantom = zeros(nGridPoints);
handles.Phantom = Phantom;
handles.Grid = Grid;
guidata(hObject, handles);

% scrolling
set(handles.slicesSlider,'Enable','Off');

% display
rtpDisplay(handles);

%
set(handles.isTarget,'BackgroundColor',[0 1 0]);

% --------------------------------------------------------------------
function barTablesLoad_Callback(hObject, eventdata, handles)
% hObject    handle to barTablesLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in up.
function up_Callback(hObject, eventdata, handles)
% hObject    handle to up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% generate first grid
%nGridPoints = 256;  % grid size
%posPhantom = [0, 0];    % phantom at grid
userGrid = handles.Grid;
userCenter = userGrid.center;
userPhantom = handles.Phantom;

% change position moving
posCenter = userCenter;
posCenter(2) = userCenter(2) - 1; % up

% new grid
Grid = rtpGrid(userPhantom, posCenter);

% save user data
handles.Grid = Grid;
guidata(hObject, handles);

% display
rtpDisplay(handles);

% --- Executes on button press in down.
function down_Callback(hObject, eventdata, handles)
% hObject    handle to down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
userGrid = handles.Grid;
userCenter = userGrid.center;
userPhantom = handles.Phantom;

% change position moving
posCenter = userCenter;
posCenter(2) = userCenter(2) + 1; % down

% new grid
Grid = rtpGrid(userPhantom, posCenter);

% save user data
handles.Grid = Grid;
guidata(hObject, handles);

% display
rtpDisplay(handles);

% --- Executes on button press in left.
function left_Callback(hObject, eventdata, handles)
% hObject    handle to left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
userGrid = handles.Grid;
userCenter = userGrid.center;
userPhantom = handles.Phantom;

% change position moving
posCenter = userCenter;
posCenter(1) = userCenter(1) - 1; % left

% new grid
Grid = rtpGrid(userPhantom, posCenter);

% save user data
handles.Grid = Grid;
guidata(hObject, handles);

% display
rtpDisplay(handles);

% --- Executes on button press in right.
function right_Callback(hObject, eventdata, handles)
% hObject    handle to right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
userGrid = handles.Grid;
userCenter = userGrid.center;
userPhantom = handles.Phantom;

% change position moving
posCenter = userCenter;
posCenter(1) = userCenter(1) + 1; % right

% new grid
Grid = rtpGrid(userPhantom, posCenter);

% save user data
handles.Grid = Grid;
guidata(hObject, handles);

% display
rtpDisplay(handles);

% --- Executes on slider movement.
function slicesSlider_Callback(hObject, eventdata, handles)
% hObject    handle to slicesSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% choose slice
nSlice = round(get(handles.slicesSlider,'Value'));
Phantom = handles.phantomSlices(:, :, nSlice);

% generate first grid
%nGridPoints = max([size(Phantom,1), size(Phantom, 2)]);
posCenter = [handles.Grid.center(1), handles.Grid.center(2)];               % phantom at grid

Grid = rtpGrid(Phantom, posCenter);

% save user data
handles.Phantom = Phantom;
handles.Grid = Grid;
guidata(hObject, handles);

% display
rtpDisplay(handles);

% --- Executes during object creation, after setting all properties.
function slicesSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slicesSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in setFieldFactor.
function setFieldFactor_Callback(hObject, eventdata, handles)
% hObject    handle to setFieldFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in setScatterFactor.
function setScatterFactor_Callback(hObject, eventdata, handles)
% hObject    handle to setScatterFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in setTMRFactor.
function setTMRFactor_Callback(hObject, eventdata, handles)
% hObject    handle to setTMRFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in setWFFactor.
function setWFFactor_Callback(hObject, eventdata, handles)
% hObject    handle to setWFFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in revPLan.
function revPLan_Callback(hObject, eventdata, handles)
% hObject    handle to revPLan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[handles.Vectors, handles.Wedge] = rtpRevisor(handles.Vectors, handles.Grid, handles.D, handles.Wedge);

% save user data
guidata(hObject, handles);

% --- Executes on button press in runPlan.
function runPlan_Callback(hObject, eventdata, handles)
% hObject    handle to runPlan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

userGrid = handles.Grid;
userBeam = handles.Beam;
userVectors = handles.Vectors;
userWedge = handles.Wedge;

showplan = get(handles.showDebug,'Value');

[Plan, d] = rtpPlan(userGrid, userBeam, userVectors, userWedge, showplan);

% save user data
handles.Plan = Plan;
handles.D.d = d;

%handles.Dose = Dose;
guidata(hObject, handles);

% display
rtpOverlayDisplay(handles);

%
muPlan_Callback(hObject, eventdata, handles);

%
if (get(handles.showSnapshot,'Value'))
    snapshot_Callback(hObject, eventdata, handles)
end

% --- Executes on button press in muPlan.
function muPlan_Callback(hObject, eventdata, handles)
% hObject    handle to muPlan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Dose
handles.D.D = str2double(get(handles.setDose,'String')) * 10^-2; % Gy

% Choose
Choice(1) = get(handles.setFieldFactor,'Value');
Choice(2) = get(handles.setScatterFactor,'Value');
Choice(3) = get(handles.setTMRFactor,'Value');
Choice(4) = get(handles.setWFFactor,'Value');

% Tables
Tables.TablesTMR = handles.TablesTMR;
Tables.TablesFSY = handles.TablesFSY;
Tables.TablesWF = handles.TablesWF;

% MU
handles.MU = rtpMU(handles.Vectors, Tables, handles.D, Choice);

%
guidata(hObject, handles);

% display results
h = figure('Position', [440 500 200 200],'Name','MU','Resize','off');
set(h,'menubar','none','numbertitle','off')
d = [handles.Vectors.angle handles.MU.Values];
% Create the column and row names in cell arrays
cnames = {'Angle (deg)','MU'};
rnames = {1:handles.Vectors.N};
% Create the uitable
t = uitable(h,'Data',d,'ColumnName',cnames,'RowName',rnames, 'Position', [0 0 200 200]);

% --- Executes on key press with focus on rtpGui or any of its controls.
function rtpGui_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to rtpGui (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

switch eventdata.Key
    case 'w'
        up_Callback(hObject, eventdata, handles);
    case 'a'
        left_Callback(hObject, eventdata, handles);
    case 's'
        down_Callback(hObject, eventdata, handles);
    case 'd'
        right_Callback(hObject, eventdata, handles);
    case 'uparrow'
        up_Callback(hObject, eventdata, handles);
    case 'downarrow'
        down_Callback(hObject, eventdata, handles);
    case 'leftarrow'
        left_Callback(hObject, eventdata, handles);
    case 'rightarrow'
        right_Callback(hObject, eventdata, handles);
    otherwise
end

% --- Executes on button press in showSnapshot.
function showSnapshot_Callback(hObject, eventdata, handles)
% hObject    handle to showSnapshot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in showAxis.
function showAxis_Callback(hObject, eventdata, handles)
% hObject    handle to showAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of showAxis
if (get(handles.showAxis,'Value'))
    axis on;
else
    axis off;
end

% --- Executes on button press in showDebug.
function showDebug_Callback(hObject, eventdata, handles)
% hObject    handle to showDebug (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in snapshot.
function snapshot_Callback(hObject, eventdata, handles)
% hObject    handle to snapshot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


h1 = figure(666);
set(h1,'numbertitle','off','Pointer','crosshair')

% homemade display
subplot(1,2,1), imagesc(handles.Grid.grid);
axis image
[N, M] = size(handles.Grid.grid);
hold on;
line([1:N],M/2*ones(1,N),'Color',[0 0 0]);
line(N/2*ones(1,M),[1:M],'Color',[0 0 0]);
hold off;
colormap(jet); freezeColors; 
title('Te\chila');
xlabel(colorbar,'Intensity (HU)');

% plan
imgPlan = handles.Plan;  % Gy

% mask of marked region
bd = handles.Grid.bound;
imgMask = im2bw(handles.DoseMask);
imgPlan(bd(1):bd(2)-1, bd(3):bd(4)-1) = imgPlan(bd(1):bd(2)-1, bd(3):bd(4)-1) .* imgMask;

% target
imgTarget = mat2gray(handles.Grid.grid) *  max(max(imgPlan));

% homemade display
subplot(1,2,2), imagesc(imgTarget); colormap(bone); freezeColors;
axis image
% start
hold on;

% show plan
h = imagesc(imgPlan); colormap(jet);

% transparency
tMap = rtpTransparency(handles.Grid.grid, 450, 0.55);

% display
set(h, 'AlphaData', tMap);

% contour of isodose
contour(imgPlan, 7);

% finish
hold off;

% labels
%title(sprintf('Te\\chila | d_{ref}=%.1fcm D_{cal}=%.3fGy',handles.D.dref, handles.D.dose));
title(sprintf('Te\\chila'));
xlabel(colorbar,'%');
