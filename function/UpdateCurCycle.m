function handles = UpdateCurCycle(handles)
% update current cycle
if handles.cursor <= length(handles.preview_sample)
    handles.cur_cycle = 0;
    handles.preview_flag = 1;
else
    handles.cur_cycle = ceil((handles.cursor - length(handles.preview_sample)) / handles.row);
    handles.preview_flag = 0;
end
end