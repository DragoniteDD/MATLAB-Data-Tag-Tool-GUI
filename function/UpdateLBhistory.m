function handles = UpdateLBhistory(handles)
% update listbox history
idx = num2str(handles.cursor - length(handles.preview_sample));
rl = num2str(handles.labels(handles.history(handles.cursor), handles.cur_cycle+1));
handles.Text = cat(1, ['Subject ', idx, ': ', rl], handles.Text);
set(handles.lbHistory, 'string', handles.Text)
end