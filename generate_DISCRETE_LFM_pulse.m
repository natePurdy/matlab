% generate from scratch a pulse train of an LFM signal
function [res_pulses] = generate_DISCRETE_LFM_pulse( tau, B, pulse_dur_ms, num_pulses, t_array, PRT_ms, noise )
    
    % THE PURPOSE OF THIS FUNCTION IS TO GENERATE A SPECIFIC LFM PULSE
    % TRAIN FOR ASSISTING IN ECE538 PROJECT 1, QUESTION 2 AND 2 (MORE SO 3)

    % on time = off time (starting simple, maybe change duty cycle later)
    pulse_envelope = [ones(1,pulse_dur_ms) zeros(1,length(t_array)-pulse_dur_ms)];
    % remaining pulses
    for i=1:num_pulses
        
        % generate the new pulse
        func_temp = pulse_envelope.*exp(1i*pi*(B/tau).*(t_array).*(t_array));
        func_temp = func_temp + noise;
        if i < 2
            res_pulses = func_temp;
        else
            % shift over the old pulses to make room for the new one
            old_pulses = circshift(res_pulses, PRT_ms);
            % concatenate them, removing the "zero filled portion of the
            % old pulse after shifting" and replace that with the new pulse
            res_pulses = [func_temp(1:PRT_ms) old_pulses(PRT_ms:length(old_pulses)-1)]; 
        end
    end
end

