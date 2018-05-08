function handles = butNext(handles)
% butNext callback function
if isempty(handles.remaining) && handles.cur_cycle == handles.num_cycles && handles.cursor == length(handles.history)
    warndlg('\fontsize{14}Congratulations! All work has been done! Thank you for your help! Please remember to save your work!', 'Thank You!', handles.warndlg_opts);
    % update buttons
    handles = UpdateRLbut(handles);
elseif handles.cursor == length(handles.history) && handles.labels(handles.history(end), handles.cur_cycle+1) == -1
    warndlg('\fontsize{14}Please label a risk level for your latest signal before moving forward.', 'Risk Level Needed for Current Subject', handles.warndlg_opts);
else
    % update cursor
    handles.cursor = handles.cursor + 1;
    handles.save_flag = 0;
    
    % update cur_cycle
    handles = UpdateCurCycle(handles);
    
    if handles.cursor > length(handles.history)
        if isempty(handles.remaining)
            handles.remaining = (1:handles.row)';
        end
        idx = randsample(length(handles.remaining), 1);
        handles.history = cat(1, handles.history, handles.remaining(idx));
        handles.remaining(idx) = [];
    end
    
    % update editJump
    set(handles.editJump, 'string', num2str(length(handles.history) - length(handles.preview_sample)))
    
    % update buttons
    handles = UpdateRLbut(handles);
    
    % update plot
    handles = UpdatePlot(handles);
end
end