clc
close all
clear

%                                               PROBLEM 1
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% 1) Select the appropriate parameters for generating a LFM waveform using matlab, and write
% down the parameters you are using. (Note that please directly generate the LFM using
% exponential function. The Matlab build-in function will hardly help you to understand the
% waveform and debugging.)

%--------------------------------------- SOME WAVEFORM PARAMETER SETTING  ---
tau = 1; % 1 S duration
B = 100; % bandwidth 50hZ
fc = 30000000000; %carrier f 30 GHz
t = 0:0.00001:1; %observe wave for 1 seconds? (MULTIPLY BY TAU????)
% square envelope for 0.1 seconds?
at = ones(1,length(t)); % chirp for full second (envelope)
noise = normrnd(0,1,size(t)); % add some noise to make it more interesting

% GENERATE A TRANSMIT CHIRP WAVEFORM
og_chirp = generateLFMwaveform(tau,B,t,"upChirp",at, 0);;

% PLOT THE TRANSMITTED WAVEFORM
figure
figure1 = tiledlayout(2,1);
axes1 = nexttile;
scatter(axes1,t/tau,real(og_chirp),".", "red")
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

% USE A FACTOR THE SAME SIGNAL THAT WAS SENT AS THE RETURN
xt = generateLFMwaveform(tau,B,t,"upChirp",at, noise);
% define the return signal if there were no noise present
xt_ideal = generateLFMwaveform(tau,B,t,"upChirp",at, 0);
% make the "return signal" 100 times smaller than the "transmitted signal"
% (trying to very simply model power loss --> signal amplitude reduction)
xt = 0.001*xt;
xt_ideal = 0.001*xt_ideal;


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
scatter(axes4,[-1:0.00001:1]/tau, yt, ".","blue")
ylabel(axes4,"Amplitude")
xlabel(axes4,"normalized time t/tau")
title(axes4,"Output of Matched Filter y(t)")
        
% ---------------- MAGNITUDE SPECTRUM RESPONSE of Matched filter output ----------
axes5 = nexttile;
scatter(axes5,[-1:0.00001:1]/tau,10*log(yt),".","blue")
ylabel(axes5,"Amplitude (dB)")
xlabel(axes5,"normalized time t/tau")
title(axes5,"Output of Matched Filter y(t) in Decibels")
[freqs, amps, phase] = simpleFFT(yt,2000);
axes6 = nexttile;
scatter(axes6,freqs/B,10*log(abs(amps)),".","blue")
ylabel(axes6,"Amplitude (dB)")
xlabel(axes6,"normalized time t/tau")
title(axes6,"FFT of Matched Filter Output y(t)")

% 3) According to the waveform in question (1), simulate the reflected signal with noise from two
% point targets. After matched filter, show the situation when the two targets are resolvable and
% unresolvable in figure. (Note that please directly generate the matched filer response according
% to the waveform you generated in step 1. The Matlab build-in function will hardly help you to
% understand the waveform and debugging.)

% For this, my initial thought was to mock the return signals from 2
% targets using a 2-pulse LFM signal, with the pulses being some time delay
% apart

% define some parameters of the LFM pulse train 
pulse_dur_ms = tau*1000; % same duration as signal from first part of the project, now in ms bc my function is dumb
num_pulses = 3; % two targets
t_array = 0:0.001:4; % 4 seconds of "viewing"
PRT_ms = 2000; % repeating every 2000 ms (2 seconds)
noise = normrnd(0,1,size(t_array)); % additive noise

% generate the signals (using parameters defined above)
return_signal_pulse_train = generate_DISCRETE_LFM_pulse_train(tau, B, pulse_dur_ms, num_pulses, t_array, PRT_ms, 0 );
return_signal_pulse_train_plusNoise = generate_DISCRETE_LFM_pulse_train(tau, B, pulse_dur_ms, num_pulses, t_array, PRT_ms, noise );

% plot the signals
figure 
tiledlayout(3,1)
nexttile
scatter(t_array,return_signal_pulse_train,'.',"blue")
ylabel("Amplitude")
xlabel("time (s)")
title("Return Signal w/o Noise")
nexttile
scatter(t_array,return_signal_pulse_train_plusNoise,'.',"red")
ylabel("Amplitude")
xlabel("time (s)")
title("Return Signal w/ Noise")

% run it through a matched filter
out = apply_matched_filter(return_signal_pulse_train_plusNoise);
nexttile
plot(-4:0.001:4,out)
ylabel("Amplitude")
xlabel("time (s)")
title("Output of Matched Filter y(t)")

% Please turn in a report with the figures you generated for each question. Also explain what you
% found in word. The report is not necessary to be long, but it should response to the questions
% clearly.

% Note: Please do not use matlab build-in function for generating LFM. Please use the function
% "exp" to generate the waveform, as it will help you to consider the sample rate, bandwidth,
% duration, and matched filter response.

% For writing the simulation, you can try to:
% 1. generate signal x_t
% 2. generate noise (can be Gaussian Noise) n_t
% 3. add x_t with n_t and generate y_t
% 4. convolve y_t with matched filter system response
% For simulating multiple targets, you need to generate multiple x_t with different time delays.

function [chirp_signal] = generateLFMwaveform(tau, bandwidth, time, direction, carrier, noise)

  
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


function [frq, amp, phase] = simpleFFT( signal, ScanRate)

    % NOTE I GOT THIS FROM:
    % https://mechanicalvibration.com/Making_matlab_s_fft_functio.html 

    % it seemed more straightfowrard on how to use the fft() that the
    % matlab documentation was

    % function [frq, amp, phase] = simpleFFT( signal, ScanRate)
    % Purpose: perform an FFT of a real-valued input signal, and generate the single-sided 
    % output, in amplitude and phase, scaled to the same units as the input.
    %inputs: 
    %    signal: the signal to transform
    %    ScanRate: the sampling frequency (in Hertz)
    % outputs:
    %    frq: a vector of frequency points (in Hertz)
    %    amp: a vector of amplitudes (same units as the input signal)
    %    phase: a vector of phases (in radians)
    n = length(signal); 
    z = fft(signal, n); %do the actual work
    
    %generate the vector of frequencies
    halfn = floor(n / 2)+1;
    deltaf = 1 / ( n / ScanRate);
    frq = (0:(halfn-1)) * deltaf;
    
    % convert from 2 sided spectrum to 1 sided
    %(assuming that the input is a real signal)
    
    amp(1) = abs(z(1)) ./ (n);
    amp(2:(halfn-1)) = abs(z(2:(halfn-1))) ./ (n / 2); 
    amp(halfn) = abs(z(halfn)) ./ (n); 
    phase = angle(z(1:halfn));
end





