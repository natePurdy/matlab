clear all 
close all
clc


Fs = 1000;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = 200;             % Length of signal
t = 0.1e-6:0.1e-6:20e-6;       % Time vector

fc = 200e3;
X= exp(1i.*2.*pi.*fc.*t);
%Plot the noisy signal in the time domain. It is difficult to identify the frequency components by looking at the signal X(t).

%Compute the Fourier transform of the signal.

Y = fft(X);
%Compute the two-sided spectrum P2. Then compute the single-sided spectrum P1 based on P2 and the even-valued signal length L.

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
%Define the frequency domain f and plot the single-sided amplitude spectrum P1. The amplitudes are not exactly at 0.7 and 1, as expected, because of the added noise. On average, longer signals produce better frequency approximations.
f = Fs*(0:(L/2))/L;
plot(f,P1) 
title("Single-Sided Amplitude Spectrum of X(t)")
xlabel("f (Hz)")
ylabel("|P1(f)|")