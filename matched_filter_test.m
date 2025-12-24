
clear 
close all


% set up the waveforms
% ------------------------------------------------------------------------HOME-MADE
% The signal may then look as follows:
% parameter setting
B = 200;
tau = 0.5; %pulse length
CF = B*tau; % compression factor, USE >> 1, may come in handy later
num_pulses = 1; % one targets
resolution = 0.001; % for plotting, and FFT, and altering depending on how large the B*tau C.F. becomes
PRT = 1; % repeating every 1 second
t_array = 0:resolution:num_pulses*1; %  time of "viewing"
noise = 0; % additive noise
time_delay = 0;
center_pulse_time = time_delay + tau/2;
[x_transmit, real_part, imag_part, t_array,clean] = gen_LFM_at_specific_time(tau, B, num_pulses, t_array, PRT, 0, time_delay, resolution);

% apply homemade matched filter to signal
[yt_mine, t_mine] = apply_matched_filter(clean,clean, t_array, resolution, center_pulse_time);



 % ------------------------------------------------------------------- IN HOUSE
waveform = phased.LinearFMWaveform('PulseWidth',0.5,'PRF',2,...
    'SampleRate',1e3,'OutputFormat','Pulses','NumPulses',1,...
    'SweepBandwidth',200);
wav = getMatchedFilter(waveform);
filter = phased.MatchedFilter('Coefficients',wav);
sig = waveform();
t = linspace(0,numel(sig)/waveform.SampleRate,...
    waveform.SampleRate/waveform.PRF);

% compare my waveform to the in house waveform
figure 
plot(t, real(sig))
hold on
plot(t_array, real(clean), 'r')


yt = filter(sig);

% show the results
figure
plot(t,abs(yt))
figure
plot(t_mine, abs(yt_mine))
x = 1;

% WHY THE HELL IS MY MATCHED FILTER OUTPUT ALSWAYS SHIFTED TO THE END OF
% THE TIME ARRAY OF WHICH IT WAS FED