function handles = UpdateButtons(handles, turn)
% Enable the push buttons and text boxes
set(handles.butLoadWork, 'enable', turn)
set(handles.butResetWork, 'enable', turn)
set(handles.butSaveWork, 'enable', turn)
set(handles.butPrevious, 'enable', turn)
set(handles.butNext, 'enable', turn)
set(handles.butGo, 'enable', turn)

set(handles.textJump, 'enable', turn)
set(handles.editJump, 'enable', turn)
set(handles.textAuthor, 'enable', turn)
set(handles.textFN, 'enable', turn)
set(handles.textLN, 'enable', turn)
set(handles.editFN, 'enable', turn)
set(handles.editLN, 'enable', turn)

handles = UpdateRLbut(handles);
end