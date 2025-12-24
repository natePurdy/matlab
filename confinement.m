close all;
% Compute the confinement factor for a slab waveguide in 1D

% Refractive indices
n_top = 1.452;
n_core = 1.936;
n_bottom = 1.452;

% Thicknesses in microns
d_top = 6;
d_core = 0.045;
d_bottom = 15;

% Wavelength in microns
lambda = 1.55;

% Constants
k0 = 2 * pi / lambda;

% Define spatial domain
x_min = -d_bottom - 5;  % extend beyond bottom cladding
x_max = d_top + d_core + 5;  % extend beyond top cladding
x = linspace(x_min, x_max, 10000);  % fine spatial grid
dx = x(2) - x(1);

% Define region boundaries
x_core_start = 0;
x_core_end = d_core;

x_top_start = d_core;
x_bottom_end = -d_bottom;

% Estimate effective index
n_eff = (n_core + max(n_top, n_bottom)) / 2;
beta = k0 * n_eff;

% Transverse wavevectors / decay constants
k_core = sqrt((k0 * n_core)^2 - beta^2);
alpha_top = sqrt(beta^2 - (k0 * n_top)^2);
alpha_bottom = sqrt(beta^2 - (k0 * n_bottom)^2);

% Define field profile Ex(x)
Ex = zeros(size(x));

for i = 1:length(x)
    xi = x(i);
    if xi < 0  % bottom cladding
        Ex(i) = exp(alpha_bottom * xi);
    elseif xi <= d_core  % core
        Ex(i) = cos(k_core * (xi - d_core/2));  % centered cosine
    else  % top cladding
        Ex(i) = exp(-alpha_top * (xi - d_core));
    end
end

% Normalize field (optional)
Ex = Ex / max(abs(Ex));

% Compute |E|^2
Ex2 = abs(Ex).^2;

% Total power
P_total = sum(Ex2) * dx;

% Core power: only where x in [0, d_core]
core_indices = (x >= 0) & (x <= d_core);
P_core = sum(Ex2(core_indices)) * dx;

% Confinement factor
Gamma = P_core / P_total;

% Display result
fprintf('Confinement Factor (1D): %.6f\n', Gamma);

