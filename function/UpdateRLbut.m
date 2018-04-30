function handles = UpdateRLbut(handles)
% update risk level buttons
if handles.preview_flag
    set(handles.textSafe, 'enable', 'off')
    set(handles.textRisky, 'enable', 'off')
    set(handles.textHistory, 'enable', 'off')
    set(handles.lbHistory, 'enable', 'off')
    
    set(handles.butRL0, 'enable', 'off')
    set(handles.butRL1, 'enable', 'off')
    set(handles.butRL2, 'enable', 'off')
    set(handles.butRL3, 'enable', 'off')
    set(handles.butRL4, 'enable', 'off')
    
else
    set(handles.textSafe, 'enable', 'on')
    set(handles.textRisky, 'enable', 'on')
    set(handles.textHistory, 'enable', 'on')
    set(handles.lbHistory, 'enable', 'on')
    
    set(handles.butRL0, 'enable', 'on')
    set(handles.butRL1, 'enable', 'on')
    set(handles.butRL2, 'enable', 'on')
    set(handles.butRL3, 'enable', 'on')
    set(handles.butRL4, 'enable', 'on')
    
    switch handles.labels(handles.history(handles.cursor), handles.cur_cycle+1)
        case 0
            set(handles.butRL0, 'enable', 'off')
        case 1
            set(handles.butRL1, 'enable', 'off')
        case 2
            set(handles.butRL2, 'enable', 'off')
        case 3
            set(handles.butRL3, 'enable', 'off')
        case 4
            set(handles.butRL4, 'enable', 'off')
    end
end
end

