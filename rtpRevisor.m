function varargout = rtpRevisor(varargin)
% RTPREVISOR MATLAB code for rtpRevisor.fig
%      RTPREVISOR, by itself, creates a new RTPREVISOR or raises the existing
%      singleton*.
%
%      H = RTPREVISOR returns the handle to a new RTPREVISOR or the handle to
%      the existing singleton*.
%
%      RTPREVISOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RTPREVISOR.M with the given input arguments.
%
%      RTPREVISOR('Property','Value',...) creates a new RTPREVISOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before rtpRevisor_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to rtpRevisor_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help rtpRevisor

% Last Modified by GUIDE v2.5 07-Dec-2015 14:52:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @rtpRevisor_OpeningFcn, ...
                   'gui_OutputFcn',  @rtpRevisor_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
               
% varargin 1 = headers
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before rtpRevisor is made visible.
function rtpRevisor_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to rtpRevisor (see VARARGIN)

% loading
handles.Vectors = varargin{1};
handles.Grid = varargin{2};
handles.D = varargin{3};
handles.Wedge = varargin{4};

Data = [handles.Vectors.angle, handles.Vectors.size, handles.Vectors.weight, handles.Vectors.wedge];

set(handles.revTable,'Data', Data);

% Choose default command line output for script
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes script wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = rtpRevisor_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
%varargout{1} = handles.output;
varargout{1} = handles.Vectors;
varargout{2} = handles.Wedge;

delete(handles.figure1);

% --- Executes when entered data in editable cell(s) in revTable.
function revTable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to revTable (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

idx = eventdata.Indices;

switch idx(2)
    case 1
        handles.Vectors.angle(idx(1)) = eventdata.NewData;
    case 2
        handles.Vectors.size(idx(1)) = eventdata.NewData;
        handles.Vectors.sizeEq(idx(1)) = eventdata.NewData;
    case 3
        handles.Vectors.weight(idx(1)) = eventdata.NewData;
    case 4
        handles.Vectors.wedge(idx(1)) = eventdata.NewData;
    otherwise
        disp('Error')
end

% Update handles structure
guidata(hObject, handles);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if isequal(get(hObject, 'waitstatus'), 'waiting')
% The GUI is still in UIWAIT, us UIRESUME
uiresume(hObject);
else
% The GUI is no longer waiting, just close it
delete(hObject);
end
