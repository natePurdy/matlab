%% Optics midterm equations of interest
close all;
clear;

%% ctrl + enter to run section


%% Guassian pulse problem regarding autocorrelation figure
c=3e8; lambda = 1550e-9;
numInterPeaksInFWHMregion = 12; % count them
wavePeriod = lambda/c
FWHM_TIME = numInterPeaksInFWHMregion*wavePeriod
FWHM_FREQ = 0.44/FWHM_TIME
%convert pulse spread inf freq to spectral BW
FWHM_wavelength = FWHM_FREQ*(lambda^2)/c

% part c pulse spreading
timeSpread = 1e-12;
GVD = 20e-12;  % 20 ps^2/km
GVD_meters = GVD*10^-15;
LengthSilica = (timeSpread*FWHM_TIME)/(4*log(2)*GVD_meters)

% part d
% Time axis
t = linspace(-10, 10, 4096);  % Extended time axis for better resolution
dt = t(2) - t(1);             % Time step

% Pulse parameters
tau = 1;      % Pulse width
A = 1;        % Amplitude
C = 5;        % Chirp parameter

% Unchirped pulse (Gaussian)
E0 = A * exp(-t.^2 / (2 * tau^2));

% Chirped pulse: E(t) = E0(t) * exp(i * C * t^2)
E_chirp = E0 .* exp(1i * C * t.^2);

% Preallocate autocorrelation results
ACF_unchirped = zeros(size(t));
ACF_chirped = zeros(size(t));

% Compute field autocorrelation manually
for idx = 1:length(t)
    tau_shift = t(idx);
    E0_shifted = interp1(t, E0, t - tau_shift, 'linear', 0);
    E_chirp_shifted = interp1(t, E_chirp, t - tau_shift, 'linear', 0);

    ACF_unchirped(idx) = trapz(t, E0 .* conj(E0_shifted));
    ACF_chirped(idx) = trapz(t, E_chirp .* conj(E_chirp_shifted));
end

% Take magnitude (real part would be zero-centered, magnitude is envelope)
ACF_unchirped = abs(ACF_unchirped);
ACF_chirped = abs(ACF_chirped);

% Normalize
ACF_unchirped = ACF_unchirped / max(ACF_unchirped);
ACF_chirped = ACF_chirped / max(ACF_chirped);

% Plotting
figure;
plot(t, ACF_unchirped, 'b-', 'LineWidth', 2); hold on;
plot(t, ACF_chirped, 'r--', 'LineWidth', 2);
xlabel('Time Delay \tau');
ylabel('Normalized Field Autocorrelation');
title('Field Autocorrelation of Unchirped vs. Chirped Pulse');
legend('Unchirped Pulse', 'Chirped Pulse');
grid on;


%% Question regardin fabry perot resonator
n_e = 1.553; n_o = 1.544; R1 = 0.9; R2 = R1; d = 0.003;

FSR_e = c/(pi*d*n_e)
FSR_o = c/(pi*d*n_o)

lineWidth_e = -log(R1*R2)*FSR_e/(2*pi)
lineWidth_o = -log(R1*R2)*FSR_o/(2*pi)

% Create mesh grid for ellipsoid
[x, y, z] = ellipsoid(0, 0, 0, 1/n_o, 1/n_o, 1/n_e, 100);

% Plot the index ellipsoid
figure;
surf(x, y, z, 'FaceAlpha', 0.6, 'EdgeColor', 'none');
colormap(jet);
axis equal;
xlabel('x (1/n_o)');
ylabel('y (1/n_o)');
zlabel('z (1/n_e)');
title('Index Ellipsoid of a Uniaxial Crystal');

% Add vector arrows for ordinary and extraordinary axes
hold on;
quiver3(0,0,0,1/n_o,0,0,0.8,'k','LineWidth',2);  % x - ordinary
quiver3(0,0,0,0,1/n_o,0,0.8,'k','LineWidth',2);  % y - ordinary
quiver3(0,0,0,0,0,1/n_e,0.8,'r','LineWidth',2);  % z - extraordinary

% Labels
text(1/n_o+0.02,0,0,'Ordinary Axis (x)', 'FontSize',10);
text(0,1/n_o+0.02,0,'Ordinary Axis (y)', 'FontSize',10);
text(0,0,1/n_e+0.02,'Extraordinary Axis (z)', 'FontSize',10);

grid on;
view(135, 20);


% Constants
FSRe = FSR_e; % Extraordinary FSR (Hz)
FSRo = FSR_o; % Ordinary FSR (Hz)

% Assumed parameters
linewidth_e = lineWidth_e;  % Linewidth for extraordinary mode (Hz)
linewidth_o = lineWidth_o;  % Linewidth for ordinary mode (Hz)

% Frequency axis
N_lines = 101;                    % Number of comb lines
f_center = 2e14;                  % Central frequency (e.g., 200 THz ~ 1500 nm)
f_span = 1e12;                    % +/- frequency span (Hz)
f = linspace(f_center - f_span, f_center + f_span, 5000); % Frequency axis

% Generate frequency positions of comb lines
lines_e = f_center + (-floor(N_lines/2):floor(N_lines/2)) * FSRe;
lines_o = f_center + (-floor(N_lines/2):floor(N_lines/2)) * FSRo;

% Initialize magnitude arrays
spectrum_e = zeros(size(f));
spectrum_o = zeros(size(f));

% Lorentzian function definition
lorentz = @(f, f0, gamma) ( (gamma/2).^2 ) ./ ( (f - f0).^2 + (gamma/2).^2 );

% Construct spectra
for k = 1:length(lines_e)
    spectrum_e = spectrum_e + lorentz(f, lines_e(k), linewidth_e);
    spectrum_o = spectrum_o + lorentz(f, lines_o(k), linewidth_o);
end

% Normalize
spectrum_e = spectrum_e / max(spectrum_e);
spectrum_o = spectrum_o / max(spectrum_o);

% Plot
figure;
plot(f*1e-12, spectrum_e, 'b', 'LineWidth', 1.5); hold on;
plot(f*1e-12, spectrum_o, 'r', 'LineWidth', 1.5);
xlabel('Frequency (THz)');
ylabel('Normalized Magnitude');
title('Optical Frequency Comb: Ordinary vs Extraordinary');
legend('Extraordinary (FSRe)', 'Ordinary (FSRo)');
grid on;

% Input polarization angle (degrees) relative to ordinary axis
theta_deg = 45; % 0 = all ordinary, 90 = all extraordinary
theta_rad = deg2rad(theta_deg);

% Power split
P_o = cos(theta_rad)^2;
P_e = sin(theta_rad)^2;

% Multiply spectra by corresponding power
spectrum_o = P_o * spectrum_o;
spectrum_e = P_e * spectrum_e;

% Combine spectra
total_spectrum = spectrum_o + spectrum_e;

% Plot
figure;
plot(f*1e-12, spectrum_o, 'r--', 'LineWidth', 1.2); hold on;
plot(f*1e-12, spectrum_e, 'b--', 'LineWidth', 1.2);
plot(f*1e-12, total_spectrum, 'k', 'LineWidth', 2);
xlabel('Frequency (THz)');
ylabel('Normalized Power');
title(['Combined Spectrum with \theta = ' num2str(theta_deg) '°']);
legend('Ordinary', 'Extraordinary', 'Total');
grid on;


%% for hybrid waveguide problem

% self consistency condition for TE modes:
% Parameters
% Parameters (can change)
close all;
% Parameters (you can change these)
lambda = 1.55e-6;          % Wavelength [m]
n1 = 1.5;                  % Core refractive index
n2 = 1.0;                  % Cladding refractive index (for theta_c)
d = 10e-6;                  % Waveguide thickness [m]
m = 1;                     % Mode number (set as needed)

% Critical angle
theta_c_rad = asin(n2 / n1);      % in radians
theta_c_deg = rad2deg(theta_c_rad);

% Angle range (start just above critical angle to avoid complex values)
theta_deg = linspace(theta_c_deg + 0.1, 89, 10000);
theta_rad = deg2rad(theta_deg);  % Convert to radians

% Compute the argument of the tangent function
arg = -pi * m + (2 * pi * d * n1 / lambda) * sin(theta_rad) - pi/2;

% Compute the function
f_theta = tan(arg);

% Limit large values to avoid plot blow-up near vertical asymptotes
f_theta(abs(f_theta) > 10) = NaN;  % Hide asymptotes

% Compute the additional function: sqrt(sin(theta_c)/sin(theta) - 1)
g_theta = sqrt((sin(theta_c_rad) ./ sin(theta_rad)) - 1);

% Handle invalid values (where expression becomes complex)
g_theta(imag(g_theta) ~= 0 | isnan(g_theta)) = NaN;

% Plot both functions
figure;
plot(theta_deg, f_theta, 'b', 'LineWidth', 2); hold on;
plot(theta_deg, g_theta, 'r', 'LineWidth', 2);
yline(0, '--k');

xlabel('\theta_m (degrees)');
ylabel('Function Value');
title([', m = ' num2str(m)]);

grid on;
ylim([-10, 10]);  % Control y-limits for better visibility

%% tiny teeny waveguide
n_1 = 1.452; n_o = 1.936; n_s = 1.453;
lambda = 1550e-9; d_core = 45e-9;
avgRefract = (n_1+n_s)/2;
Vnum = (2*pi*d_core/lambda)*(sqrt(n_o^2-n_s^2))
if 2*d/lambda < 2.4
    disp('Single mode only spported')
end

% use universal dispersion curve to find normalized propagation constant b
b = 0.1; % for example, 
beta = (2*pi/lambda)*sqrt(avgRefract^2 + b*(n_o^2-avgRefract^2))

% for confinement factor
theta_c = asin(avgRefract/n_o)
theta_m = asin(sqrt(b*(n_o^2-avgRefract^2))/n_o^2); % current angle of incidence corresponds with m=0 fundumental mode
theta_c_c = pi/2-theta_c
M = (sin(theta_c)/lambda/2*d_core);
Sm = sin(theta_m)/sin(theta_c);
p2_p1 = (Sm/sqrt(1-Sm^2))*(1+(-1)^M*cos(pi*M*Sm))/(pi*M*Sm + (-1)^M*sin(pi*M*Sm))
confinementFactor = 1/(1+p2_p1)