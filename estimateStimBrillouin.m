% estimate teh power threshold for stimulated brilloin scattering for
% SMF28.
% You need to estimate the power threshold for stimulated Brillouin scattering in case of short
% pulse propagation in SMF28 (fiber specifications are shown below). You can use the formula
% provided in class which was derived for the CW case but there is a caveat. To apply this formula
% for short pulses you need to consider the effective length differently. When the pump pulse is
% launched into the fiber it generates the Brillouin pulse (which carries very little power at first but
% then grows exponentially, due to the Brillouin gain created by the pump pulse). Since the pump
% and Brillouin pulses have different wavelengths (the Brillouin shift is ~0.08 nm for pump at 1550
% nm) they propagate in the fiber with different group velocities (due to dispersion). After some
% propagation distance (equal to the walk-off length) they will walk-off from each other (in time)
% and no energy transfer happens anymore. The walk-off length can be considered as the effective
% length (or the interaction length). You can do the calculation with the assumption that the
% FWHM input pulse duration is 100 fs (transform-limited), the center wavelength is at 1550 nm.
% The two pulses are considered not to be overlapped in time if the distance between them equal to
% or greater than the FWHM duration of the pulse. You can use gB =5*10-11 m/W.
% SMF28 parameters of interest:
%% Fiber and pulse parameters
diameter = 8.3e-6; % core diameter (not directly needed)
NA = 0.13;
MFD = 10.4e-6; % mode field diameter (m)

FWHM_inT = 100e-15; % input pulse FWHM (s)
loss_dB = 0.19; % fiber loss (dB/km)
dispersion = 17; % ps/(nm·km)
BGB = 50e6; % Brillouin gain bandwidth (Hz)
brillouinShift = 0.08; % nm
gB = 5*10^-11; % given gB value from problem

%% Attenuation coefficient (in 1/m)
attenCoeff = (loss_dB / 4.343) / 1e3; % convert dB/km to 1/m

%% Calculate walk-off limited effective length
deltaT = dispersion * brillouinShift; % ps/km
L_eff = FWHM_inT / (deltaT * 1e-12); % convert ps/km -> s/m
fprintf('Walk-off-limited effective length: %.2f m\n', L_eff);

%% === Effective Area Calculations ===
% 1. Approximation (Gaussian mode)
A_eff_approx = (pi/4) * MFD^2;

% 2. Numerical integration using definition
w = MFD/2; % mode radius (1/e^2 intensity radius)
r = linspace(0, 5*w, 1e5); % radial coordinate (up to 5*w is plenty)
I = exp(-2*(r/w).^2);

num = trapz(r, 2*pi*r.*I);      % ∫ I(r) 2πr dr
den = trapz(r, 2*pi*r.*I.^2);   % ∫ I^2(r) 2πr dr
A_eff_int = (num^2) / den;

%% Compare results
fprintf('\n--- Effective Area Comparison ---\n');
fprintf('Approximation:    A_eff = %.3e m^2\n', A_eff_approx);
fprintf('Numerical (int):  A_eff = %.3e m^2\n', A_eff_int);
fprintf('Difference:       %.3f %%\n', abs(A_eff_int - A_eff_approx)/A_eff_approx*100);

% broullioun threshold power estimate
Pthreshold = 21*A_eff_int/(gB*L_eff)
