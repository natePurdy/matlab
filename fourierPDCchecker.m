close all; clear;
syms t w

% Define the function
% F_x = t^2*exp(-abs(t));
syms t T

F_x = heaviside(t + T) - heaviside(t - T);

% Compute Fourier transform
X = fourier(F_x, t, w)

% Simplify (optional)
X_simplified = simplify(X)

% result is_even will be zero if function is even
is_even = simplify( subs(F_x, t, -t) - F_x )


%%%% IF YOU REEAALLLLYYY want to plot it
% Parameters
Fs = 10000;          % Sampling frequency (Hz)
T = 1/Fs;           % Sampling period
L = 1000;           % Length of signal
t = (0:L-1)*T;      % Time vector

F_x = t.^2.*exp(-abs(t)); % redefine in deicrete time
% Compute Fourier transform
X = fft(F_x);

% Compute two-sided spectrum
P2 = abs(X/L);

% Compute single-sided spectrum
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

% Frequency axis
f = Fs*(0:(L/2))/L;

% Plot
figure;
plot(f, P1)
title('Single-Sided Amplitude Spectrum of F(t)')
xlabel('Frequency (Hz)')
ylabel('|X(f)|')
grid on;

