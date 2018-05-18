function handles = UpdatePlot(handles)
% update plot
axes(handles.plot)
% cla('reset')
if handles.cursor > 0
    idx = handles.history(handles.cursor);
    L = length(handles.PPGa{idx});
    t = (1:L) / handles.SF - handles.baseline(idx, 1); % unit: second
    t = t / 60; % unit: minute
    MAX = max(handles.PPGa{idx});
    % MED = median(handles.PPGa{idx});
    baseline = handles.baseline(idx,:)/60;
    % Snum = handles.cursor - length(handles.preview_sample) - handles.row*(max(handles.cur_cycle-1,0));
    Snum = handles.cursor - length(handles.preview_sample);
    
    hold off
    plot([-20, 60], [1, 1], 'k', 'linewidth', 1.5)
    hold on
    % plot([-20, 60], MED * ones(2,1), 'k', 'linewidth', 1.5)
    plot([-20, 60], 0.5 * ones(2,1), 'k', 'linewidth', 1.5)
    plot([0, 0], [0, max(1.1*MAX,2)], 'r', 'linewidth', 1.5)
    plot((baseline(2)-baseline(1)) * ones(2,1), [0, max(1.1*MAX,2)], 'r', 'linewidth', 1.5)
    
    plot(t, handles.PPGa{idx});
    
    if get(handles.cbFixY, 'Value')
        axis([-20, 60, 0, 2])
        text(-19.8, 1.05, '95th percentile', 'color', 'black', 'Fontsize', 12)
        text(-19.8, 0.55, '0.5 for reference', 'color', 'black', 'Fontsize', 12)
        text(0.2, 0.05, 'Baseline', 'color', 'red', 'Fontsize', 12)
    else
        axis([-20, 60, 0, 1.1*MAX])
        text(-19.8, 1+0.025*MAX, '95th percentile', 'color', 'black', 'Fontsize', 12)
        text(-19.8, 0.5+0.025*MAX, '0.5 for reference', 'color', 'black', 'Fontsize', 12)
        text(0.2, 0.025*MAX, 'Baseline', 'color', 'red', 'Fontsize', 12)
    end
    grid on
    xlabel('Time (minute)', 'Fontsize', 14)
    ylabel('PPGa / Oxipamp', 'Fontsize', 14)
    % title(['Subject ', num2str(Snum), ', Cycle: ', num2str(handles.cur_cycle)], 'Fontsize', 16)
    title(['Signal ', num2str(Snum), '/', num2str(handles.row*handles.num_cycles)], 'Fontsize', 16)
end
end

