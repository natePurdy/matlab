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

clc
clear 
close all

tiledlayout(4,1)


%---------------------- PLOTTING ------------------------%
%---------------------- PLOTTING ------------------------%
% plot the original signal
fc = 200000
nexttile
Fs = 450000;                    % Sampling frequency
T = 1/Fs;                     % Sampling period
L = 200;                     % Length of signal
t_plot = (0.1e-6:0.1e-6:20e-6);
t = (0.1e-6:0.1e-6:20e-6)*T;               

rt = exp(1i*2*pi*fc*t);

plot(t_plot,rt)
title('Signal Of Interest')



% Top plot% some calculations ....
% some calculations ....
rt = exp(j*2*pi*fc*t);
fft_res = fft(rt, 2000);
P2 = abs(fft_res/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
% some calculations ....
nexttile
f = Fs*(0:(L/2))/L;
plot(f,P1)
title("Fourier Transform of Signal - N=2000, plus time")

%------------------------- Middle Plot ----
% Plot FFT of the sinsoid signal using 2000 points FFT transform, i.e. (N=2000).
% some calculations ....
t = 0:Ts:20e-6;
x = exp(1i*2*pi*fc*t);
plot(t,x)
xlabel('Time (seconds)')
ylabel('Amplitude')


y = fft(x);
fs = 1/Ts;
f = (0:length(y)-1)*fs/length(y);

nexttile
plot(f,abs(y))
xlabel('Frequency (Hz)')
ylabel('Magnitude')
title('Magnitude')

title("Fourier Transform of Signal - N=2000")
% 3) Change t to t=0.1e-6: 0.1e-6:200e-6, and do 2000 points FFT transform.
%------------------------Bottom plot ----
% some calculations ....
t = 0:Ts:20e-6;
x = exp(1i*2*pi*fc*t);
plot(t,x)
xlabel('Time (seconds)')
ylabel('Amplitude')


y = fft(x);
fs = 1/Ts;
f = (0:length(y)-1)*fs/length(y);

nexttile
plot(f,abs(y))
xlabel('Frequency (Hz)')
ylabel('Magnitude')
title('Magnitude')






