clear; close all;
syms t b w r c real
assume(b > 0)
assume(r > 0)
assume(c > 0)

%%% GIVEN
h_t = (1/(r*c))*exp(-t/(r*c))*heaviside(t);
Rx_t = exp(-b*abs(t));

%%% --- MANUAL FOURIER TRANSFORM OF Rx(t) ---

% Split into negative and positive parts manually
Rx_neg = exp(-b*(-t));   % t < 0 → |t| = -t
Rx_pos = exp(-b*( t));   % t > 0 → |t| =  t

% FFT is done on each part of the function for t>0 and t<0
Sx_w_neg = int(Rx_neg * exp(-1i*w*t), t, -inf, 0);
Sx_w_pos = int(Rx_pos * exp(-1i*w*t), t,  0, inf);

Sx_w = simplify(Sx_w_neg + Sx_w_pos, 'IgnoreAnalyticConstraints', true)

%%% --- MANUAL FOURIER TRANSFORM OF h(t) ---

% Only integrate from 0 to ∞ because system is causal
H_w = int((1/(r*c))*exp(-t/(r*c)) * exp(-1i*w*t), t, 0, inf);
H_w = simplify(H_w, 'IgnoreAnalyticConstraints', true)

% the autocorrelation of the output (inverse FT)
% Output PSD
% Output PSD
Sy_f = simplify(abs(H_w)^2 * Sx_w, 'IgnoreAnalyticConstraints', true)

% Output autocorrelation via inverse FT
Ry_t = (1/(2*pi)) * int(Sy_f * exp(1i*w*t), w, -inf, inf);
Ry_t = simplify(Ry_t, 'IgnoreAnalyticConstraints', true)