function handles = MarkRL(handles, RL)
% mark risk level for a subject/study
% update tags and lbHistory
handles.tags(handles.history(handles.cursor), handles.cur_cycle+1) = RL;
handles = UpdateLBhistory(handles);

% automatically move to the next subject if the current subject is the
% newest one (to work on) so far
if handles.cursor == length(handles.history)
    handles = butNext(handles);
else
    % update buttons
    handles = UpdateRLbut(handles);
end
end