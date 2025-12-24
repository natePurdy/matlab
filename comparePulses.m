close all

% Parameters
T = 1;                        % Pulse width parameter
N = 2^14;                    % Number of points for FFT (power of two)
t_max = 100* T;              % Time window half-width
t = linspace(-t_max, t_max, N);
dt = t(2) - dt(1);

% Pulse definitions
E_exp  = exp(-abs(t/T));                  % Two-sided exponential
E_lor  = 1 ./ (1 + (t / T).^2);             % Lorentzian
E_rect = double(abs(t) <= T/2);             % Rectangular pulse
E_sech = 1 ./ cosh(t / T);                   % Hyperbolic secant
E_gaus = exp(- 0.5*(t / T).^2);                  % Gaussian

% --- Helper function to compute FWHM ---
compute_FWHM = @(x, y) ...
    fwhm_from_data(x, y);

% --- Compute FWHM in time domain ---
FWHM_exp_time  = compute_FWHM(t, E_exp);
FWHM_lor_time  = compute_FWHM(t, E_lor);
FWHM_rect_time = compute_FWHM(t, E_rect);
FWHM_sech_time = compute_FWHM(t, E_sech);
FWHM_gaus_time = compute_FWHM(t, E_gaus);

% --- Plot time domain ---
figure;
plot(t, E_exp,  'b-',  'LineWidth', 2); hold on;
plot(t, E_lor,  'r--', 'LineWidth', 2);
plot(t, E_rect, 'g-.', 'LineWidth', 2);
plot(t, E_sech, 'm:',  'LineWidth', 2);
plot(t, E_gaus, 'k-',  'LineWidth', 1.5);

% Mark FWHM on time domain curves
plot_FWHM(t, E_exp,  FWHM_exp_time,  'b');
plot_FWHM(t, E_lor,  FWHM_lor_time,  'r');
plot_FWHM(t, E_rect, FWHM_rect_time, 'g');
plot_FWHM(t, E_sech, FWHM_sech_time, 'm');
plot_FWHM(t, E_gaus, FWHM_gaus_time, 'k');

xlabel('Time t');
ylabel('Amplitude');
title('Comparison of Common Pulse Shapes (Time Domain)');
legend('Two-Sided Exponential', 'Lorentzian', 'Rectangular', 'Hyperbolic Secant', 'Gaussian');
grid on;
ylim([-0.1 1.1]);
xlim([-5*T, 5*T]);

% --- Compute FFT and frequency vector ---
Fs = 1/dt;                   % Sampling frequency
f = linspace(-Fs/2, Fs/2, N);

% FFTs (scaled by dt for proper integral approx)
FFT_exp  = fftshift(fft(E_exp))  * dt;
FFT_lor  = fftshift(fft(E_lor))  * dt;
FFT_rect = fftshift(fft(E_rect)) * dt;
FFT_sech = fftshift(fft(E_sech)) * dt;
FFT_gaus = fftshift(fft(E_gaus)) * dt;

% Magnitude spectra normalized to max = 1
Mag_exp  = abs(FFT_exp)  / max(abs(FFT_exp));
Mag_lor  = abs(FFT_lor)  / max(abs(FFT_lor));
Mag_rect = abs(FFT_rect) / max(abs(FFT_rect));
Mag_sech = abs(FFT_sech) / max(abs(FFT_sech));
Mag_gaus = abs(FFT_gaus) / max(abs(FFT_gaus));

% --- Compute FWHM in frequency domain ---
FWHM_exp_freq  = compute_FWHM(f, Mag_exp);
FWHM_lor_freq  = compute_FWHM(f, Mag_lor);
FWHM_rect_freq = compute_FWHM(f, Mag_rect);
FWHM_sech_freq = compute_FWHM(f, Mag_sech);
FWHM_gaus_freq = compute_FWHM(f, Mag_gaus);

% --- Plot frequency domain ---
figure;
plot(f, Mag_exp,  'b-',  'LineWidth', 2); hold on;
plot(f, Mag_lor,  'r--', 'LineWidth', 2);
plot(f, Mag_rect, 'g-.', 'LineWidth', 2);
plot(f, Mag_sech, 'm:',  'LineWidth', 2);
plot(f, Mag_gaus, 'k-',  'LineWidth', 1.5);

% Mark FWHM on frequency domain curves
plot_FWHM(f, Mag_exp,  FWHM_exp_freq,  'b');
plot_FWHM(f, Mag_lor,  FWHM_lor_freq,  'r');
plot_FWHM(f, Mag_rect, FWHM_rect_freq, 'g');
plot_FWHM(f, Mag_sech, FWHM_sech_freq, 'm');
plot_FWHM(f, Mag_gaus, FWHM_gaus_freq, 'k');

xlabel('Frequency (Hz)');
ylabel('Normalized Magnitude');
title('Comparison of Fourier Transforms of Common Pulses');
legend('Two-Sided Exponential', 'Lorentzian', 'Rectangular', 'Hyperbolic Secant', 'Gaussian');
grid on;
xlim([-5/T, 5/T]); % Focus on main spectral lobe

% ===== Helper functions =====
function FWHM = fwhm_from_data(x, y)
    % Computes the full width at half max for data vectors (x,y)
    y = y / max(y); % Normalize max to 1
    half_max = 0.5;
    indices = find(y >= half_max);
    if isempty(indices)
        FWHM = NaN; % no crossing found
        return;
    end
    left_idx = indices(1);
    right_idx = indices(end);
    FWHM = x(right_idx) - x(left_idx);
end

function plot_FWHM(x, y, FWHM, color)
    % Plot markers and text annotation for FWHM
    y = y / max(y);
    half_max = 0.5;
    indices = find(y >= half_max);
    if isempty(indices)
        return;
    end
    left_idx = indices(1);
    right_idx = indices(end);
    xl = x([left_idx, right_idx]);
    yl = y([left_idx, right_idx]);
    plot(xl, yl, 'o', 'Color', color, 'MarkerSize', 8, 'MarkerFaceColor', color);

    % Display text above the curve midpoint
    x_text = mean(xl);
    y_text = max(yl) + 0.1;
    text_str = sprintf('FWHM=%.3f', FWHM);
    text(x_text, y_text, text_str, 'Color', color, 'FontWeight', 'bold', ...
         'HorizontalAlignment', 'right');
end