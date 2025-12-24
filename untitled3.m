%ECE538 – Radar Signal Processing Sep. 7, 2023
% University of Arizona, Autumn 2023 Due: Sep. 21, 2023
% Problem Set 2
% 1. Use matlab to generate a sinsoid signal r(t)=exp(j.*2.*pi.*fc.*t), where fc = 200e3, and
% set time to be t=0.1e-6: 0.1e-6:20e-6.
% 1) Use command fft(x, N) to plot FFT of the sinsoid signal using 200 points FFT transform,
% i.e. (N=200)
% 2) Plot FFT of the sinsoid signal using 2000 points FFT transform, i.e. (N=2000).
% 3) Change t to t=0.1e-6: 0.1e-6:200e-6, and do 2000 points FFT transform.
% 4) Compare the differences between 1), 2), and 3).
% %

close all
clear all


fc = 200000; % CONSTANT
Fs = 2*fc;                    % Sampling frequency
T = 1/Fs;                     % Sampling period
t = 0.1e-6:0.1e-6:20e-6;               % Time vector for signal
L = length(t);                     % Length of signal


rt = cos(2.*pi.*fc.*t)+1i*sin(2.*pi.*fc.*t);

Y = fft(rt,L,2)
P2 = abs(Y/L);
P1 = P2(:,1:L/2+1);
P1(:,2:end-1) = 2*P1(:,2:end-1);
plot(0:(Fs/L):(Fs/2-Fs/L),P1(1:L/2))
title(" In the Frequency Domain")
