% % % generate from scratch a pulse train of an LFM signal, at a time that may
% % % represent a targets range
% % % here we are trying to simulate a traget return from a distnace of: 
% % % R = ct/2
% % 
% % define some parameters of the LFM pulse train 
% B = 1000;
% tau = 0.1; %pulse length
% slope = B/tau;
% num_pulses = 5; % one targets
% resolution = 0.0001;
% PRT = 0.5; % repeating every 1 second
% t_array = 0:resolution:num_pulses*1.5; % 1 seconds of "viewing"
% noise = 0; % additive noise
% time_delay = 0.05;
% x = gen_LFM_at_specific_time(tau, B, num_pulses, t_array, PRT, noise, time_delay, resolution);

function [res_sig, real_part, imag_part, t_array,clean] = gen_LFM_at_specific_time( tau, B, num_pulses, t_array, PRT,noise, time_delay, resolution )
    
    % THE PURPOSE OF THIS FUNCTION IS TO GENERATE A SPECIFIC LFM PULSE
    % TRAIN FOR ASSISTING IN ECE538 PROJECT 1, QUESTION 2 AND 2 (MORE SO 3)

    % on time = off time (starting simple, maybe change duty cycle later)
    lower_half = int32(tau/resolution);
    upper_half = int32(length(t_array)-tau/resolution);
    pulse_envelope = [ones(1, lower_half) zeros(1,upper_half)];
    % remaining pulses
    for i=1:num_pulses
        
        % generate the new pulse
        func_temp = pulse_envelope.*exp(1i*pi*(B/tau).*(t_array).*(t_array));
    
        if i < 2
            res_pulses = func_temp;
        else
            % shift over the old pulses to make room for the new one
            old_pulses = circshift(res_pulses, PRT/resolution);
            % concatenate them, removing the "zero filled portion of the
            % old pulse after shifting" and replace that with the new pulse
            % PRT/resolution is how many points in our discreate chain we
            % need to shift
            res_pulses = [func_temp(1:PRT/resolution) old_pulses(PRT/resolution:length(old_pulses)-1)]; 
        end
    end
    % now that we have the pulse LFM complete, fill the surrounding time with
    % zeros, and maybe noise if you are feeling crazy

    res_sig = [zeros(1, time_delay/resolution) res_pulses];
    %assuming using ms as the resulotion of processing
    t_array = 0:resolution:(length(res_sig)-1)*resolution;
    
    noise = normrnd(0,1,size(t_array));
    clean= res_sig;
    res_sig = res_sig + noise;
    

    real_part = real(res_sig);
    imag_part = imag(res_sig);
end
