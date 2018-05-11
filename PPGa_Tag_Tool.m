function varargout = PPGa_Tag_Tool(varargin)
% PPGA_TAG_TOOL MATLAB code for PPGa_Tag_Tool.fig
%      PPGA_TAG_TOOL, by itself, creates a new PPGA_TAG_TOOL or raises the existing
%      singleton*.
%
%      H = PPGA_TAG_TOOL returns the handle to a new PPGA_TAG_TOOL or the handle to
%      the existing singleton*.
%
%      PPGA_TAG_TOOL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PPGA_TAG_TOOL.M with the given input arguments.
%
%      PPGA_TAG_TOOL('Property','Value',...) creates a new PPGA_TAG_TOOL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PPGa_Tag_Tool_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PPGa_Tag_Tool_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above textHistory to modify the response to help PPGa_Tag_Tool

% Last Modified by GUIDE v2.5 02-May-2018 15:04:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PPGa_Tag_Tool_OpeningFcn, ...
                   'gui_OutputFcn',  @PPGa_Tag_Tool_OutputFcn, ...
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


% --- Executes just before PPGa_Tag_Tool is made visible.
function PPGa_Tag_Tool_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PPGa_Tag_Tool (see VARARGIN)

% Choose default command line output for PPGa_Tag_Tool
handles.output = hObject;

% Identify codepath, add folders & subfolders to path
[handles.codepath, ~, ~] = fileparts(mfilename('fullpath'));
addpath(genpath(handles.codepath));

% Set dialog box options
handles.warndlg_opts = struct('WindowStyle','modal','Interpreter','tex');
handles.questdlg_opts = struct('Default', 'Cancel', 'Interpreter', 'tex');

% Set alt_flag for hotkeys
handles.alt_flag = 0;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PPGa_Tag_Tool wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PPGa_Tag_Tool_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in butLoadData.
function butLoadData_Callback(hObject, eventdata, handles)
% hObject    handle to butLoadData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% warn if current work has not been saved
if isfield(handles, 'save_flag') && ~handles.save_flag
    confirm = questdlg('\fontsize{14}Load data will discard your unsaved work, do you still want to continue?', 'Warning Message', handles.questdlg_opts);
end

if ~exist('confirm', 'var') || strcmp(confirm, 'Yes')
    % load data
    cur_path = pwd;
    if isfield(handles, 'datapath') && ~isequal(handles.datapath, 0)
        cd(handles.datapath)
    end
    [datafile, datapath] = uigetfile('*.mat', 'Select the data file (.mat format)');
    if ~isequal(datapath, 0)
        handles.datapath = datapath;
    end
    cd(cur_path)
    
    % if the selected file is valid
    if ~isequal(datafile, 0)
        % load raw data
        data = load(fullfile(handles.datapath, datafile));
        if ~isfield(data, 'PPGa') || ~isfield(data, 'SF') || ~isfield(data, 'baseline') || ~isfield(data, 'preview_sample')
            warndlg('\fontsize{14}The data file does not contain all required fields. Please select the correct file.', 'File Error', handles.warndlg_opts);
        else
            handles.PPGa = data.PPGa;
            handles.row = length(handles.PPGa);
            handles.SF = data.SF;
            handles.baseline = data.baseline;
            handles.preview_sample = data.preview_sample;
            handles.num_cycles = 3;
            
            % work data initialization
            handles = InitializeWork(handles, handles.num_cycles);
            handles.save_flag = 1;
            
            % update lbHistory
            set(handles.lbHistory, 'string', handles.Text)
            
            % update editJump
            set(handles.editJump, 'string', num2str(length(handles.history) - length(handles.preview_sample)))
            
            % update buttons
            handles = UpdateButtons(handles, 'on');
            
            % update plot
            handles = UpdatePlot(handles);
            
            % update author
            set(handles.editFN, 'string', handles.author.FN)
            set(handles.editLN, 'string', handles.author.LN)
        end
    end
end

% Update handles structure
guidata(hObject,handles);

% --- Executes on button press in butLoadWork.
function butLoadWork_Callback(hObject, eventdata, handles)
% hObject    handle to butLoadWork (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% warn if current work has not been saved
if ~handles.save_flag
    confirm = questdlg('\fontsize{14}Load work will discard your unsaved work, do you still want to continue?', 'Warning Message', handles.questdlg_opts);
end

if ~exist('confirm', 'var') || strcmp(confirm, 'Yes')
    % default work path
    if ~isfield(handles, 'workpath') || isequal(handles.workpath, 0)
        handles.workpath = handles.datapath;
    end
    
    % load work
    cur_path = pwd;
    cd(handles.workpath)
    [workfile, workpath] = uigetfile('*.mat', 'Select the work file (.mat format)');
    if ~isequal(workpath, 0)
        handles.workpath = workpath;
    end
    cd(cur_path)
    
    % if selected file is valid
    if ~isequal(workfile, 0)
        % load existing work
        work = load(fullfile(handles.workpath, workfile));
        if ~isfield(work, 'labels') || ~isfield(work, 'preview_flag') || ~isfield(work, 'history') || ...
                ~isfield(work, 'cursor') || ~isfield(work, 'cur_cycle') || ~isfield(work, 'remaining') || ...
                ~isfield(work, 'author')
            warndlg('\fontsize{14}The work file does not contain all required fields. Please select the correct file.', 'File Error', handles.warndlg_opts);
        elseif size(work.labels,1) ~= handles.row
            warndlg('\fontsize{14}The work file is for some dataset with different number of signals. Please select the correct file.', 'File Error', handles.warndlg_opts);
        else
            handles.labels = work.labels;
            handles.preview_flag = work.preview_flag;
            handles.history = work.history;
            handles.cursor = work.cursor;
            handles.cur_cycle = work.cur_cycle;
            handles.remaining = work.remaining;
            handles.author = work.author;
            handles.save_flag = 1;
            
            % reset lbHistory
            handles.Text = {};
            set(handles.lbHistory, 'string', handles.Text)
            
            % update editJump
            set(handles.editJump, 'string', num2str(length(handles.history) - length(handles.preview_sample)))
            
            % update buttons
            handles = UpdateRLbut(handles);
            
            % update plot
            handles = UpdatePlot(handles);
            
            % update author
            set(handles.editFN, 'string', handles.author.FN)
            set(handles.editLN, 'string', handles.author.LN)
        end
    end
end

% Update handles structure
guidata(hObject,handles);


% --- Executes on button press in butResetWork.
function butResetWork_Callback(hObject, eventdata, handles)
% hObject    handle to butResetWork (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% warn if current work has not been saved
if ~handles.save_flag
    confirm = questdlg('\fontsize{14}Reset work will discard your unsaved work, do you still want to continue?', 'Warning Message', handles.questdlg_opts);
end

if ~exist('confirm', 'var') || strcmp(confirm, 'Yes')
    handles = InitializeWork(handles, handles.num_cycles);
    handles.save_flag = 1;
    
    % update lbHistory
    set(handles.lbHistory, 'string', handles.Text)
    
    % update editJump
    set(handles.editJump, 'string', num2str(length(handles.history) - length(handles.preview_sample)))
    
    % update buttons
    handles = UpdateRLbut(handles);
    
    % update plot
    handles = UpdatePlot(handles);
    
    % update author
    set(handles.editFN, 'string', handles.author.FN)
    set(handles.editLN, 'string', handles.author.LN)
end

% Update handles structure
guidata(hObject,handles);


% --- Executes on button press in butPrevious.
function butPrevious_Callback(hObject, eventdata, handles)
% hObject    handle to butPrevious (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = butPrevious(handles);

% Update handles structure
guidata(hObject,handles);


% --- Executes on button press in butNext.
function butNext_Callback(hObject, eventdata, handles)
% hObject    handle to butNext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = butNext(handles);

% Update handles structure
guidata(hObject,handles);


function editJump_Callback(hObject, eventdata, handles)
% hObject    handle to editJump (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editJump as text
%        str2double(get(hObject,'String')) returns contents of editJump as a double


% --- Executes during object creation, after setting all properties.
function editJump_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editJump (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in butGo.
function butGo_Callback(hObject, eventdata, handles)
% hObject    handle to butGo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

idx = str2double(get(handles.editJump, 'string'));
if idx ~= int32(idx)
    warndlg('\fontsize{14}Please enter an integer as signal index to jump to.', 'Wrong Index', handles.warndlg_opts);
else
    if idx + length(handles.preview_sample) > length(handles.history)
        warndlg('\fontsize{14}Please do not skip your latest signal.', 'Warning', handles.warndlg_opts);
        idx = length(handles.history) - length(handles.preview_sample);
    elseif idx <= -length(handles.preview_sample)
        warndlg('\fontsize{14}This is already the first signal.', 'Warning', handles.warndlg_opts);
        idx = 1 - length(handles.preview_sample);
    end
    % update cursor
    handles.cursor = idx + length(handles.preview_sample);
    handles.save_flag = 0;
    
    % update cur_cycle
    handles = UpdateCurCycle(handles);
    
    % update editJump
    set(handles.editJump, 'string', num2str(length(handles.history) - length(handles.preview_sample)))
    
    % update buttons
    handles = UpdateRLbut(handles);
    
    % update plot
    handles = UpdatePlot(handles);
end

% Update handles structure
guidata(hObject,handles);


% --- Executes on button press in cbFixY.
function cbFixY_Callback(hObject, eventdata, handles)
% hObject    handle to cbFixY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbFixY
UpdatePlot(handles);


function editFN_Callback(hObject, eventdata, handles)
% hObject    handle to editFN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editFN as textHistory
%        str2double(get(hObject,'String')) returns contents of editFN as a double


% --- Executes during object creation, after setting all properties.
function editFN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editFN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editLN_Callback(hObject, eventdata, handles)
% hObject    handle to editLN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editLN as textHistory
%        str2double(get(hObject,'String')) returns contents of editLN as a double


% --- Executes during object creation, after setting all properties.
function editLN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editLN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in butSaveWork.
function butSaveWork_Callback(hObject, eventdata, handles)
% hObject    handle to butSaveWork (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.author.FN = strip(get(handles.editFN, 'String'));
handles.author.LN = strip(get(handles.editLN, 'String'));

if isempty(handles.author.FN)
    warndlg('\fontsize{14}Please enter your first name to save your work. Thank you!', 'First Name Needed', handles.warndlg_opts)
elseif isempty(handles.author.LN)
    warndlg('\fontsize{14}Please enter your last name to save your work. Thank you!', 'Last Name Needed', handles.warndlg_opts)
else
    % default work path & filename
    if ~isfield(handles, 'workpath') || isequal(handles.workpath, 0)
        handles.datapath
        handles.workpath = handles.datapath;
    end
    savefile = ['Labels by ', handles.author.FN, ' ', handles.author.LN, '.mat'];

    % save work
    cur_path = pwd;
    cd(handles.workpath)
    [savefile, savepath] = uiputfile('*.mat', 'Save your work', savefile);
    if ~isequal(savepath, 0)
        handles.workpath = savepath;
    end
    cd(cur_path)
    
    % user actually defines a file to save
    if ~isequal(savefile, 0) && ~isequal(handles.workpath, 0)        
        save(fullfile(handles.workpath,savefile), '-struct', 'handles', 'labels', 'preview_flag', 'history', 'cursor', 'cur_cycle', 'remaining', 'author')
    end
    handles.save_flag = 1;
end

% Update handles structure
guidata(hObject,handles);


% --- Executes on selection change in lbHistory.
function lbHistory_Callback(hObject, eventdata, handles)
% hObject    handle to lbHistory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lbHistory contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lbHistory


% --- Executes during object creation, after setting all properties.
function lbHistory_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lbHistory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in butRL0.
function butRL0_Callback(hObject, eventdata, handles)
% hObject    handle to butRL0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Mark risk level for a signal
handles = MarkRL(handles, 0);

% Update handles structure
guidata(hObject,handles);


% --- Executes on button press in butRL1.
function butRL1_Callback(hObject, eventdata, handles)
% hObject    handle to butRL1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Mark risk level for a signal
handles = MarkRL(handles, 1);

% Update handles structure
guidata(hObject,handles);


% --- Executes on button press in butRL2.
function butRL2_Callback(hObject, eventdata, handles)
% hObject    handle to butRL2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Mark risk level for a signal
handles = MarkRL(handles, 2);

% Update handles structure
guidata(hObject,handles);


% --- Executes on button press in butRL3.
function butRL3_Callback(hObject, eventdata, handles)
% hObject    handle to butRL3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Mark risk level for a signal
handles = MarkRL(handles, 3);

% Update handles structure
guidata(hObject,handles);


% --- Executes on button press in butRL4.
function butRL4_Callback(hObject, eventdata, handles)
% hObject    handle to butRL4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Mark risk level for a signal
handles = MarkRL(handles, 4);

% Update handles structure
guidata(hObject,handles);


% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

if strcmp(eventdata.Key, 'alt')
    handles.alt_flag = 1;
elseif handles.alt_flag && ...
        (strcmp(eventdata.Key, '0') || strcmp(eventdata.Key, 'backquote') || strcmp(eventdata.Key, 'numpad0')) && ...
        strcmp(get(handles.butRL0, 'enable'), 'on')
    handles = MarkRL(handles, 0);
elseif handles.alt_flag && ...
        (strcmp(eventdata.Key, '1') || strcmp(eventdata.Key, 'numpad1')) && ...
        strcmp(get(handles.butRL1, 'enable'), 'on')
    handles = MarkRL(handles, 1);
elseif handles.alt_flag && ...
        (strcmp(eventdata.Key, '2') || strcmp(eventdata.Key, 'numpad2')) && ...
        strcmp(get(handles.butRL2, 'enable'), 'on')
    handles = MarkRL(handles, 2);
elseif handles.alt_flag && ...
        (strcmp(eventdata.Key, '3') || strcmp(eventdata.Key, 'numpad3')) && ...
        strcmp(get(handles.butRL3, 'enable'), 'on')
    handles = MarkRL(handles, 3);
elseif handles.alt_flag && ...
        (strcmp(eventdata.Key, '4') || strcmp(eventdata.Key, 'numpad4')) && ...
        strcmp(get(handles.butRL4, 'enable'), 'on')
    handles = MarkRL(handles, 4);
elseif handles.alt_flag && ...
        strcmp(eventdata.Key, 'leftarrow') && ...
        strcmp(get(handles.butPrevious, 'enable'), 'on')
    handles = butPrevious(handles);
elseif handles.alt_flag && ...
        strcmp(eventdata.Key, 'rightarrow') && ...
        strcmp(get(handles.butNext, 'enable'), 'on')
    handles = butNext(handles);
end

% Update handles structure
guidata(hObject,handles);


% --- Executes on key release with focus on figure1 or any of its controls.
function figure1_WindowKeyReleaseFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was released, in lower case
%	Character: character interpretation of the key(s) that was released
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) released
% handles    structure with handles and user data (see GUIDATA)

if strcmp(eventdata.Key, 'alt')
    handles.alt_flag = 0;
end

% Update handles structure
guidata(hObject,handles);

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% warn if current work has not been saved
if isfield(handles, 'save_flag') && ~handles.save_flag
    confirm = questdlg('\fontsize{14}You have unsaved work, do you still want to quit?', 'Warning Message', handles.questdlg_opts);
end

if ~exist('confirm', 'var') || strcmp(confirm, 'Yes')
    % Hint: delete(hObject) closes the figure
    delete(hObject);
end
