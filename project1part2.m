close all
clear 


% define some parameters of the LFM pulse train 
B = 100;
tau = 1;
pulse_dur_ms = tau*1000; % same duration as signal from first part of the project, now in ms bc my function is dumb
num_pulses = 1; % two targets
t = 0:0.001:4; % 4 seconds of "viewing"
PRT_ms = 2000; % repeating every 2000 ms (2 seconds)
noise = normrnd(0,1,size(t)); % additive noise

% generate the signals (using parameters defined above)
xt = generate_DISCRETE_LFM_pulse_train(tau, B, pulse_dur_ms, num_pulses, t, PRT_ms, 0 );
xt_ideal = generate_DISCRETE_LFM_pulse_train(tau, B, pulse_dur_ms, num_pulses, t, PRT_ms, noise );



% PLOT THE TRANSMITTED WAVEFORM
figure
figure1 = tiledlayout(2,1);
axes1 = nexttile;
scatter(axes1,t/tau,real(xt),".", "red")
title(axes1,"Real valued LFM UpChirp Waveform")
ylabel(axes1,"Amplitude")
xlabel(axes1,"norm time t/tau ")
axes2 = nexttile;
scatter(axes2,t,(B/tau)*t,".","black")
title(figure1, "Starting using Example from book Page 198")
title(axes2,"Instantaneaous Frequency of LFM Pulse (B=100Hz, tau=1s)")
ylabel(axes2,"Frequency (Hz)")
xlabel(axes2,"time (s)")


%                                                       PROBLEM 2
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% 2) According to the waveform in question (1), simulate the reflected signal with noise from a-
% single point target. Show the matched filter output. Compare the SNR before matched filter and
% after matched filter in figure.



% PLOT THE RETURN SIGNAL
figure
figure2 = tiledlayout(3,1);
title(figure2, "Return signal Characteristics")
axes2 = nexttile;
scatter(axes2,t/tau,real(xt),".")
hold on
scatter(axes2,t/tau,real(xt_ideal),".","yellow")
legend('LFM Signal w/ Noise','Original LFM signal')
title(axes2,"LFM UpChirp Return Signal")
ylabel(axes2,"Amplitude")
xlabel(axes2,"normalized time t/tau")
axes5 = nexttile;
scatter(axes5,t/tau,10*log(real(xt)),".","blue")
ylabel(axes5,"Amplitude (dB)")
xlabel(axes5,"normalized delay t/tau")
title(axes5,"LFM UpChirp Return Signal in Decibels")
% ---------------- MAGNITUDE SPECTRUM RESPONSE ----------
[freqs, amps, phase] = simpleFFT(xt,2000);
axes3 = nexttile;
scatter(axes3,freqs/B,10*log(amps),".","blue")
ylabel(axes3,"Amplitude (dB)")
xlabel(axes3,"normalized freq F/B ")
title(axes3,"FFT of Return Signal x(t)")

f2 = figure;
tiledlayout(3,1)
yt = apply_matched_filter(xt);
axes4 = nexttile;
double_time = [-1*flip(t) t]
scatter(axes4,double_time(2:end)/tau, yt, ".","blue")
ylabel(axes4,"Amplitude")
xlabel(axes4,"normalized time t/tau")
title(axes4,"Output of Matched Filter y(t)")
        




function [chirp_signal] = generate_ghetto_LFMwaveform(tau, bandwidth, time, direction, carrier, noise)

  
  my_bool = strcmp(direction,"upChirp");
  if (my_bool == 1)
      %upchirp
       chirp_signal = carrier.*exp(j*(bandwidth/tau)*pi*time.*time) + noise;
  else
      %downchirp
       chirp_signal = carrier.*exp(j*(-bandwidth/tau)*pi*time.*time) + noise;
  end

end

% generate from scratch a pulse train of an LFM signal
function [res_pulses] = generate_DISCRETE_LFM_pulse_train( tau, B, pulse_dur_ms, num_pulses, t_array, PRT_ms, noise )
    
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

function [output] = apply_matched_filter(input_signal)

    % define the system response of the matched filter (0.4 weight here)
    ht = 0.4*fliplr(conj(input_signal));
    % convolve the return signal with the filter response
    output = conv(input_signal,ht);
end

