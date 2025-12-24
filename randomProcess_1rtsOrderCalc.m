close all; clear;

syms f t r x

R_pdf = 0.1*exp(-r/10);   % exponential(10) PDF

x_t = R_pdf*cos(2*pi*f*t); % random process

% CDF of R evaluated at x/abs(cos(...))
CDF = int(R_pdf, r, 0, x/abs(cos(2*pi*f*t)))

% Pick numerical values to expose a random variable and hance valid CDF/PDF
f0 = 1;      % frequency
x0 = 0.5;    % CDF evaluated at X = 0.5

% Convert to numeric function of t ONLY
CDF_t = matlabFunction(subs(CDF, [f, x], [f0, x0]));

% Evaluate and plot
t_vals = 0:0.01:10;
y_vals = CDF_t(t_vals);

plot(t_vals, y_vals, 'LineWidth', 2);
xlabel('t');
ylabel('CDF');
title('First-order CDF over time');
grid on;