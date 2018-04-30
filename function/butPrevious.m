function handles = butPrevious(handles)
% butPrevious callback function
% warn if the cursor is already at the first preview data
if handles.cursor == 1
    warndlg('\fontsize{14}This is already the first subject/study.', 'Warning', handles.warndlg_opts);
else
    % update cursor
    handles.cursor = handles.cursor - 1;
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
end