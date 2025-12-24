

function [output, time_for_plot] = apply_matched_filter(input_signal, matched_signal, time_array, resolution, center_pulse_time )

    % define the system response of the matched filter (1.0 weight here)
    ht = 1.0*fliplr(conj(matched_signal));
    % convolve the return signal with the filter response
    output = conv(input_signal,ht);
    % construct the simulated output time of the matched filter
    % we need to center the output at the center of the pulse, pad around
    % that with extra time
    new_begin_time = center_pulse_time - time_array(end);
    new_end_time = center_pulse_time + time_array(end);
    time_for_plot = [new_begin_time:resolution:new_end_time];
    % time_for_plot = [time_array(1:length(time_array)-1) time_array(length(time_array)):resolution:(length(time_array)-1)*2*resolution]*resolution;
    % time_for_plot = [-1*flip(time_array(2:end)) time_array];
end

