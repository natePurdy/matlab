close all; clear;
T = 10;          % total time
dt = 0.001;      % time step
t = 0:dt:T;      % time vector
N = length(t);   % number of samples
alpha = 1;       % noise intensity

N_t = sqrt(alpha/dt) * randn(1, N);

Y = cumsum(N_t) * dt;

mean_Y = mean(Y);  % should be close to zero

R_Y = xcorr(Y, 'unbiased');  % unbiased autocorrelation estimate
lags = -N+1:N-1;

lags_time = lags * dt;
plot(lags_time, R_Y);
xlabel('Lag (s)');
ylabel('Autocorrelation');