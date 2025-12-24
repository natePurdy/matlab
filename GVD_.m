% plot_gvd_fused_silica.m
% This script calculates and plots the Group Velocity Dispersion (GVD)
% of fused silica using the Sellmeier equation from 1000 to 2000 nm.

clc;
clear;

% Sellmeier coefficients for fused silica (Malitson 1965)
B1 = 0.6961663;
B2 = 0.4079426;
B3 = 0.8974794;
C1 = (0.0684043)^2; % in um^2
C2 = (0.1162414)^2;
C3 = (9.896161)^2;

% Constants
c = 299792458; % speed of light in m/s

% Wavelength range in micrometers
lambda_um = linspace(1.0, 2.0, 1000); % micrometers
lambda_m = lambda_um * 1e-6;         % meters

% Sellmeier equation for refractive index
n_squared = 1 + ...
    (B1 * lambda_um.^2) ./ (lambda_um.^2 - C1) + ...
    (B2 * lambda_um.^2) ./ (lambda_um.^2 - C2) + ...
    (B3 * lambda_um.^2) ./ (lambda_um.^2 - C3);
n = sqrt(n_squared);

% First and second derivatives of n with respect to wavelength (in meters)
d_lambda = (lambda_m(2) - lambda_m(1));
dn_dlambda = gradient(n, d_lambda);
d2n_dlambda2 = gradient(dn_dlambda, d_lambda);

% Compute GVD: GVD = (λ / c) * d²n/dλ², units: s^2/m
GVD_s2_per_m = (lambda_m ./ c) .* d2n_dlambda2;

% Convert to ps^2/km:
% 1 s^2/m = 1e24 ps^2/km
GVD_ps2_per_km = GVD_s2_per_m * 1e24;

% Plot
figure;
plot(lambda_um * 1000, GVD_ps2_per_km, 'r', 'LineWidth', 2);
xlabel('Wavelength (nm)');
ylabel('GVD (ps^2/km)');
title('Group Velocity Dispersion of Fused Silica');
grid on;
xlim([1000 2000]);