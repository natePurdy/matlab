% i dont trust anything
close all
clc
clear


tau = 0.001;
B = 100000;
num_pulses = 1;
t_array = 0:0.0001:1;
PRT_ms = 0.01;
noise = 0;


signal_1 = real(exp(1i*2*pi*400*t_array) + exp(1i*2*pi*4000*t_array));
figure
plot(t_array,signal_1)

figure
[freqs, amps, phase] = simpleJacksFFT(signal_1, 10000);
plot(freqs, amps)



function [frq, amp, phase] = simpleJacksFFT(signal, ScanRate)
    
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