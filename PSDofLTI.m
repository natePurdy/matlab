% LTI system PSD stats problem
close all; clear;
syms t w
rx_t = 1/(1+t^2);
% LTI system impulse response
a = 3;
h_t = a*sin(pi*t)/(pi*t);

% find the PSD of the output random process y(t)

% output is convolution of time signals, which is more simply put multiplication of the freq signals:
% Compute Fourier transform of input and response
inputW = fourier(rx_t, t, w);
inputW = simplify(inputW)
responseW = fourier(h_t, t, w);
responseW = simplify(responseW)


% output PSD
y_w = a^2*inputW*responseW
