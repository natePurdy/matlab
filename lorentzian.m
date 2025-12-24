% Parameters
T = 1;               % Pulse width parameter
t_max = 10 * T;      % Time range (wide enough to capture tails)
N = 2^16;            % Number of points (power of 2 for FFT)
t = linspace(-t_max, t_max, N);  % Time vector
dt = t(2) - t(1);    % Time step

% Lorentzian pulse
E_t = 1 ./ (1 + (t / T).^2);

% Plot time-domain Lorentzian pulse
figure;
plot(t, E_t, 'b-', 'LineWidth', 2);
xlabel('Time (t)');
ylabel('E(t)');
title('Lorentzian Pulse in Time Domain');
grid on;

% Fourier Transform using FFT
E_f = fftshift(fft(E_t)) * dt;   % Scale by dt to approximate integral
f = linspace(-1/(2*dt), 1/(2*dt), N);  % Frequency vector

% Plot magnitude spectrum
figure;
plot(f, abs(E_f), 'r-', 'LineWidth', 2);
xlabel('Frequency (Hz)');
ylabel('|E(f)|');
title('Magnitude Spectrum of Lorentzian Pulse');
xlim([-5/T, 5/T]);  % Zoom to relevant bandwidth
grid on;