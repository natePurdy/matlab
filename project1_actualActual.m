%% 
%                                               PROBLEM 1
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
clear 
close all
clc

% 1) Select the appropriate parameters for generating a LFM waveform using matlab, and write
% down the parameters you are using. (Note that please directly generate the LFM using
% exponential function. The Matlab build-in function will hardly help you to understand the
% waveform and debugging.)

% The appropriate parameters for designing LFM waveform depend on the environment in which it might be employed
% For this project, i am assuming a very simple model for the system and that we are interested in finding
% out whats best soley based on target return signals seperated in time, represented by an LFM (or two...) at 
% a different point along the "time-axis".
%In this Simulation, the pulse envelope is a simple square pulse, that
%envelopes the entire LFM chirp for time tau

% The parameters for an LFM waveform are :

% 1. Envelope
% 2. tau
% Bandwidth (B)
% xt = envelope*exp(j*pi*tau*B(t/tau)^2)
% i chose parameters based off of the textbook example as a start, then i may go back and change parameters after everything looks okay

% but instead made the envelope function a simple square pulse

% The signal may then look as follows:
% parameter setting
B = 100;
tau = 1; %pulse length
CF = B*tau; % compression factor, USE >> 1, may come in handy later
num_pulses = 1; % one targets
resolution = 0.0001; % for plotting, and FFT, and altering depending on how large the B*tau C.F. becomes
PRT = 2; % repeating every 1 second
t_array = 0:resolution:num_pulses*2; %  time of "viewing"
noise = 0; % additive noise
time_delay = 0;
pulse_center = time_delay + tau/2;

% Now Generate the signal points
[x_transmit, real_part, imag_part, t_array,clean] = gen_LFM_at_specific_time(tau, B, num_pulses, t_array, PRT, noise, time_delay, resolution);

% take the FFT of the transmitted signal
[tx_fft_freqs, tx_fft_amps, tx_fft_phases] = simpleFFT(clean,1/resolution);

% PLOT THE TRANSMITTED WAVEFORM
figure
figure1 = tiledlayout(3,1);
title(figure1, "Transmit Signal Characteristics")
axes1 = nexttile;
scatter(axes1,0:resolution:tau+tau/2,real(clean((1:length(0:resolution:tau+tau/2)))),".", "black")
title(axes1,"Real valued LFM UpChirp Waveform")
ylabel(axes1,"Amplitude")
xlabel(axes1," Time (s)")
fontsize(axes1, 'increase')
%  PLOT THE     slope of the transmitted waveform frequency
axes2 = nexttile;
scatter(axes2, 0:resolution:tau+tau/2, (B/tau)*t_array(1:length(0:resolution:tau+tau/2)), ".", "black")
hold on
yline(B,'-','Bandwidth', 'Color','r')
hold on
xline(tau,'-','Tau','Color','b')
title(axes2,"Instantaneaous Frequency of LFM Pulse (B=100Hz, tau=1s)")
ylabel(axes2,"Frequency (Hz)")
xlabel(axes2,"Time (s)")
fontsize(axes2, 'increase')
% PLOT THE fft OF THE TRANSMITTED WAVEFORM
axes3 = nexttile;
plot(axes3,  tx_fft_freqs, abs(tx_fft_amps),"g")
title(axes3,"FFT of Transmit Signal")
ylabel(axes3,"|Amplitude|")
xlabel(axes3,"Frequency (Hz)")
fontsize(axes3, 'increase')


%% 
%                                                       PROBLEM 2
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% 2) According to the waveform in question (1), simulate the reflected signal with noise from a-
% single point target. Show the matched filter output. Compare the SNR before matched filter and
% after matched filter in figure.

% ------------------------------------------------------------------------------add some time delay to simulate a target at a specific range
time_delay = 0.2; seconds
pulse_center = time_delay; %+ tau/2; I think it should be the center of the pulse, but this would plot better for interpreting the "target time delay"


%( for matched filter, ) 
[x_return_ideal, real_part, imag_part, t_array_ideal,clean_return] = gen_LFM_at_specific_time(tau, B, num_pulses, t_array, PRT, 0, time_delay, resolution);
[x_return_ideal_MF, real_part, imag_part, t_array_ideal,clean_MF] = gen_LFM_at_specific_time(tau, B, num_pulses, t_array, PRT, 0, time_delay, resolution);
% add noise
noise = normrnd(0,1,size(t_array));
% return signal with noise
[x_return, real_part_, imag_part_, t_array,clean] = gen_LFM_at_specific_time(tau, B, num_pulses, t_array, PRT, noise, time_delay, resolution);

% maybe make the return signal much smaller in amplitude to pretend like we
% sent it somewhere and experienced losses as a result of real life
all_combined_losses = 0.001;  % A thousanth of the originally transmitted signal 
x_return = x_return *all_combined_losses; %return signal is 10000 times weaker than the transmitted signal
clean_return = clean_return*all_combined_losses;
% do the FFT of the return signal plus noise
[xr_fft_freqs, xr_fft_amps, xr_fft_phases] = simpleFFT(x_return, 1/resolution);


% now pass through matched filter
[output_of_matched_filter, double_time] = apply_matched_filter(x_return, clean_MF, t_array, resolution, pulse_center);

% now make a "range axis" for plotting target "range"  ---> 
ranges = double_time*3*10^8/(2*B);

% now compare the SNR before and after the macthed filter
% ----Before MF
noise = normrnd(0,1,size(t_array))*all_combined_losses;
noise_power = mean (abs(noise(time_delay/resolution:tau/resolution)));
signal_power = mean(abs(clean_return(time_delay/resolution:tau/resolution)));
% ------ After MF
noise_power_mf = mean (noise.^2);
signal_power_mf = mean(abs(output_of_matched_filter(time_delay/resolution:tau/resolution)));

% USe FFT to Show SNR? 
% take the FFT of the transmitted signal
[rx_fft_freqs, rx_fft_amps, rx_fft_phases] = simpleFFT(x_return,1/resolution);
[rx_fft_freqs_mf, rx_fft_amps_mf, rx_fft_phases_mf] = simpleFFT(output_of_matched_filter,1/resolution);
figure
tiledlayout(2,1)
nexttile
scatter(rx_fft_freqs, rx_fft_amps,'.','r')
title("FFT of Return Signal")
ylabel("Amplitude")
xlabel("Frequency (Hz)")
fontsize('increase')
nexttile
scatter(rx_fft_freqs_mf, rx_fft_amps_mf,'.','b')
title("FFT of Return Signal After Matched Filter")
ylabel("Amplitude")
xlabel("Frequency (Hz)")
fontsize( 'increase')
% ---------------------------------------------------------------------------------------PLOT THE RETURN SIGNAL
figure
figure2 = tiledlayout(4,1);
title(figure2, "Return Signal Characteristics")
fontsize(figure2, 'increase')
axes1 = nexttile;
scatter(axes1,t_array,real(x_return),".", 'y')
hold on
scatter(axes1,t_array,real(clean_return),".","g")
yl = yline(noise_power,'--',['Noise Pwr Avg: ' num2str(noise_power) 'W'], 'Color','r');
yl.LabelHorizontalAlignment = 'center';
yl2 = yline(signal_power,'--',['Signal Pwr Avg: ' num2str(signal_power) 'W'], 'Color','b');
yl2.LabelHorizontalAlignment = 'left';
legend('LFM Return Signal w/ Noise','LFM Return Signal w/o Noise')
title(axes1,"LFM UpChirp Return Signal")
ylabel(axes1,"Amplitude")
xlabel(axes1,"Time (s)")
fontsize(axes1, 'increase')
axes2 = nexttile;
scatter(axes2,xr_fft_freqs,abs(xr_fft_amps),".","r")
title(axes2,"FFT of Return Signal Plus Noise")
ylabel(axes2,"Amplitude")
xlabel(axes2,"Frequency")
fontsize(axes2, 'increase')
axes3 = nexttile;
scatter(axes3,double_time, abs(real(output_of_matched_filter)),".","b")
title(axes3,"Output of Matched Filter")
ylabel(axes3,"Amplitude")
xlabel(axes3,"Time (s)")
fontsize(axes3, 'increase')
nexttile
scatter(ranges/2,abs(real(output_of_matched_filter)),".",'ColorVariable',[0.0 0.0780 1])
legend('"Range of the Target"')
title("Output of Matched Filter, Range Interpretation")
ylabel("Amplitude")
xlabel("Range (m)")
fontsize('increase')

% ----------------------------------------------Plot the signals along with the avaerage power
figure
fig_power = tiledlayout(2,1);
title(fig_power, "Return Signal Characteristics")
fontsize(fig_power, 'increase')
nexttile;
scatter(t_array,abs(real(x_return)),".", 'blue')
title("LFM UpChirp Return Signal")
ylabel("| Amplitude |")
xlabel("time (s)")
fontsize( 'increase')
nexttile
scatter(double_time/2,abs(real(output_of_matched_filter)),".","g")
title("LFM UpChirp Return Signal After MF")
ylabel("| Amplitude |")
xlabel("Time (s)")
fontsize( 'increase')

% ----------------------------------------------------------------USe FFT to Show effect of MF? 
% take the FFT of the transmitted signal
[rx_fft_freqs, rx_fft_amps, rx_fft_phases] = simpleFFT(x_return,1/resolution);
[rx_fft_freqs_mf, rx_fft_amps_mf, rx_fft_phases_mf] = simpleFFT(output_of_matched_filter,1/resolution);
figure
fig_mf_FFT = tiledlayout(2,1);
title(fig_mf_FFT, "Using the FFT to Show the Effect of a Matched Filter")
nexttile
scatter(rx_fft_freqs, rx_fft_amps,'.','r')
title("FFT of Return Signal")
ylabel("Amplitude")
xlabel("Frequency (Hz)")
fontsize('increase')
nexttile
scatter(rx_fft_freqs_mf, rx_fft_amps_mf,'.','b')
title("FFT of Return Signal After Matched Filter")
ylabel("Amplitude")
xlabel("Frequency (Hz)")
fontsize( 'increase')
%% 
%                                                       PROBLEM 3
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% 
% 3) According to the waveform in question (1), simulate the reflected signal with noise from two
% point targets. After matched filter, show the situation when the two targets are resolvable and
% unresolvable in figure. (Note that please directly generate the matched filer response according
% to the waveform you generated in step 1. The Matlab build-in function will hardly help you to
% understand the waveform and debugging.)

% 
% Taking into consideration that the targets are point targets, and this is a simple simulation,
% i am going to first investigate 2 non-moving targets, and see when they are not resolvable due to overlap in 
% the timing of the return signal.   Maybe after that, i will investigate ambiguity function if time permits.
% 


% The signal may then look as follows:
% parameter setting ------------------ TARGET 1 -----------------
B = 100;
tau = 1; %pulse length
CF = B*tau; % compression factor, USE >> 1, may come in handy later
num_pulses = 1; % one targets
resolution = 0.0001; % for plotting, and FFT, and altering depending on how large the B*tau C.F. becomes
PRT = 2; % repeating every 1 second
t_array = 0:resolution:num_pulses*2; %  time of "viewing"
noise = 0; % additive noise
time_delay = 0.2; % 0.2 second delay
pulse_center1 = time_delay; %+ tau/2;
% Generate the first targets return signal
[x_return1, real_part_1, imag_part_1, t_array1,clean1] = gen_LFM_at_specific_time(tau, B, num_pulses, t_array, PRT, noise, time_delay, resolution);
[x_return1_MF, real_part_1MF, imag_part_1MF, t_array1_MF, clean1_MF] = gen_LFM_at_specific_time(tau, B, num_pulses, t_array, PRT, noise, time_delay, resolution);
% parameter setting ------------------ TARGET 2 -----------------
B = 100;
tau = 1; %pulse length
CF = B*tau; % compression factor, USE >> 1, may come in handy later
num_pulses = 1; % one targets
resolution = 0.0001; % for plotting, and FFT, and altering depending on how large the B*tau C.F. becomes
PRT = 2; % repeating every 1 second
t_array = 0:resolution:num_pulses*2; %  time of "viewing"
noise = 0; % additive noise
time_delay = 0.22; % 0.22 second delay
pulse_center2 = time_delay; %+ tau/2;
% Generate the second targets return signal
[x_return2, real_part_2, imag_part_2, t_array2, clean2] = gen_LFM_at_specific_time(tau, B, num_pulses, t_array, PRT, noise, time_delay, resolution);
[x_return2_MF, real_part_2MF, imag_part_2MF, t_array2_MF, clean2_MF] = gen_LFM_at_specific_time(tau, B, num_pulses, t_array, PRT, noise, time_delay, resolution);

% Weaken them to simulate power losses
all_combined_losses = 0.001;  % A thousanth of the originally transmitted signal 
x_return2 = x_return2*all_combined_losses;
x_return1 = x_return1*all_combined_losses;
clean1 = clean1*all_combined_losses;
clean2 = clean2*all_combined_losses;


% NOW COMBINE THE SIGNALS TO SIMULATE A SINGLE INPUT STREAM OF TIME FOR PROCESSING THE ANTENNA SIGN
% First we want to combine the "clean" return signals, then add noise (there is only "one" noise)

[combined_signal, combined_signal_time] = add_two_signals_differing_lengths(clean1,t_array1, clean2,t_array2);
%set the noise for the system
noise = normrnd(0,1,size(combined_signal_time))*all_combined_losses;    

% now add some noise
return_signal_with_noise = combined_signal + noise;

% now pass it through a matched filter (using two calls here to simulate th macthed filter activating at each point in time)
[output_of_matched_filter1, double_time1] = apply_matched_filter(x_return1, clean1_MF, t_array1, resolution, pulse_center1);
[output_of_matched_filter2, double_time2] = apply_matched_filter(x_return2, clean2_MF, t_array2, resolution, pulse_center2);

% now combine MF output for each signal
[combined_signal_MFOUT, combined_signal_time_MFOUT] = add_two_signals_differing_lengths(output_of_matched_filter1,double_time1, output_of_matched_filter2,double_time2);
figure
figure2 = tiledlayout(3,1);
title(figure2, "Mutliple Target Return Signals")
fontsize(figure2, 'increase')
axes1 = nexttile;
scatter(axes1,t_array1,x_return1,".", 'blue')
hold on
scatter(axes1, t_array2, x_return2,".","g")
legend('First Signal','Second Signal')
title(axes1,"Return Signals")
ylabel(axes1,"Amplitude")
xlabel(axes1, "Time")
fontsize(axes1, 'increase')
axes2 = nexttile;
scatter(axes2, combined_signal_time, combined_signal,".","g")
legend('Combined Signals')
title(axes2,"Return Signal Stream (Combined Target Reurns) Without Noise (2 TGT, SEP =0.05s)")
ylabel(axes2,"Amplitude")
xlabel(axes2, "Time")
fontsize(axes2, 'increase')
axes3 = nexttile;
scatter(axes3, combined_signal_time, return_signal_with_noise,".","g")
legend('Return Signal Stream (Combined Target Reurns) With Noise')
title(axes3,"Return Signal Stream, With Noise, (2 TGT, SEP = 0.005s)")
ylabel(axes3,"Amplitude")
xlabel(axes3, "Time")
fontsize(axes3, 'increase')

% matched filter stuff
figure
figure3 = tiledlayout(3,1);
nexttile
scatter(double_time1, abs(output_of_matched_filter1),".",'r')
legend('Output of Matched Filter Due to First Target')
title("Output of Matched Filter, Due to 1st TGT, With Noise")
ylabel("Amplitude")
xlabel("Time")
fontsize('increase')
nexttile
scatter(double_time2, abs(output_of_matched_filter2),".",'r')
legend('Output of Matched Filter Due to Second Target')
title("Output of Matched Filter,Due to 2nd TGT, With Noise")
ylabel("Amplitude")
xlabel("Time")
fontsize('increase')
nexttile
scatter(combined_signal_time_MFOUT, abs(combined_signal_MFOUT),".",'ColorVariable',[0.0 0.0780 1])
legend('Output of Feeding MF Combined Target Data')
title("Output of Matched Filter,Due to Both Targets Combined")
ylabel("Amplitude")
xlabel("Time")
fontsize('increase')