function handles = InitializeWork(handles, num_cycles)
% initialize the work
handles.tags = ones(handles.row, num_cycles+1) * -1;
handles.tags(:,1) = (1:handles.row)';
handles.preview_flag = 1; % is currently browsing
n = length(handles.preview_sample);
handles.history = handles.preview_sample(randsample(n, n));
[M, N] = size(handles.history);
if M < N
    handles.history = handles.history';
end
handles.cursor = 1;
handles.cur_cycle = 0;
handles.remaining = (1:handles.row)';
handles.author.FN = '';
handles.author.LN = '';
handles.Text = {};

% if no preview samples
if isempty(handles.history)
    handles.preview_flag = 0;
    handles.cur_cycle = 1;
    assert(~isempty(handles.remaining), 'There is no PPGa data.');
    idx = randsample(length(handles.remaining), 1);
    handles.history = cat(1, handles.history, handles.remaining(idx));
    handles.remaining(idx) = [];
end