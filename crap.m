close all
clear all

Fs = 450000;                    % Sampling frequency
T = 1/Fs;                     % Sampling period
L = 200;                     % Length of signal
t = (0:L-1)*T;               
X = exp(1i*2*pi*200000*t);          % First row wave
% Third row wave
plot(t(1:100),X(1:100))
title("Row "" in the Time Domain")
dim = 2;
% Compute the Fourier transform of the signals.
Y = fft(X,L);
% Calculate the double-sided spectrum and single-sided spectrum of each signal.
P2 = abs(Y/L);


plot(0:(Fs/L):(Fs/2-Fs/L),P2(1:L/2))
title(" in the Frequency Domain")
xlabel("Frequency")
ylabel("| P |")
