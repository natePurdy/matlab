% sellmeier_gvd.m
% Compute numerical derivatives of the Sellmeier equation for GVD

clear; clc;

% Physical constant
c = 299792458; % speed of light in m/s

% Sellmeier coefficients for fused silica (example)
B = [0.6961663, 0.4079426, 0.8974794];
C = [0.0684043^2, 0.1162414^2, 9.896161^2]; % µm^2

% Wavelength range (in µm)
lambda = linspace(0.2, 2.0, 1000); % µm

% Compute refractive index n(lambda)
n = sqrt(1 + B(1)*lambda.^2 ./ (lambda.^2 - C(1)) + ...
            B(2)*lambda.^2 ./ (lambda.^2 - C(2)) + ...
            B(3)*lambda.^2 ./ (lambda.^2 - C(3)));

% First and second derivatives of n w.r.t lambda using finite differences
d_lambda = lambda(2) - lambda(1); % step size
dn_dlambda = gradient(n, d_lambda);
d2n_dlambda2 = gradient(dn_dlambda, d_lambda);

% Compute GVD in s^2/m
GVD = -(lambda * 1e-6) ./ c .* d2n_dlambda2; % convert µm to m

% Optional: Convert GVD to more standard units: fs^2/mm
GVD_fs2_per_mm = GVD * 1e30 / 1e3; % (s^2/m) * 1e30 fs^2/s^2 / 1e3 mm/m

% Plot results
figure;
subplot(3,1,1);
plot(lambda, n, 'b');
xlabel('\lambda [\mum]');
ylabel('n(\lambda)');
title('Refractive Index');

subplot(3,1,2);
plot(lambda, d2n_dlambda2, 'r');
xlabel('\lambda [\mum]');
ylabel('d^2n/d\lambda^2');
title('Second Derivative of Refractive Index');

subplot(3,1,3);
plot(lambda, GVD_fs2_per_mm, 'k');
xlabel('\lambda [\mum]');
ylabel('GVD [fs^2/mm]');
title('Group Velocity Dispersion');