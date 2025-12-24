clc; clear; close all;
% design a step index fiber with zero dispersion at 1550 nm wavelength
% Constants
lambda0 = 1.55e-6;             % target wavelength [m]
c = 3e8;                       % speed of light [m/s]

% Sellmeier coefficients (fused silica)
B1 = 0.6961663;  C1 = (0.0684043)^2;
B2 = 0.4079426;  C2 = (0.1162414)^2;
B3 = 0.8974794;  C3 = (9.896161)^2;

% Wavelength grid
lambda_um = linspace(1.30, 1.60, 2000);
lambda_m  = lambda_um*1e-6;

% Fused silica refractive index
n_silica = sqrt(1 + B1*lambda_um.^2./(lambda_um.^2 - C1) + ...
                   B2*lambda_um.^2./(lambda_um.^2 - C2) + ...
                   B3*lambda_um.^2./(lambda_um.^2 - C3));

% Material dispersion
dn  = gradient(n_silica, lambda_m);
d2n = gradient(dn, lambda_m);
D_mat = -(lambda_m./c).*d2n * 1e6;   
D_mat_1550 = interp1(lambda_um, D_mat, 1.55);

% Sweep ranges
a_vals    = linspace(1e-6, 5e-6, 100);   % core radius
n2_vals   = linspace(1.40, 1.50, 100);   % cladding index
Delta_vals = linspace(0.1, 0.001, 20); % Δ (relative index difference)

fprintf("Sweeping a, n2, and Delta parameter space...\n");

%% Storage for results: [a, n2, Delta, Dw, Dt]
results = [];

% MAIN SWEEP of parameters for radius and n2
for id = 1:length(Delta_vals)      % sweep Delta
    Delta = Delta_vals(id);

    for ia = 1:length(a_vals)      % sweep core radius
        for in = 1:length(n2_vals) % sweep cladding index

            a  = a_vals(ia);
            n2 = n2_vals(in);

            % core index from Delta
            n1 = n2 / sqrt(1 - 2*Delta);

            % --- Waveguide dispersion calculation ---
            V = (2*pi*a ./ lambda_m) .* sqrt(n1^2 - n2^2);
            % Reject fibers with V < 1.5 (b-approximation becomes invalid)
            if V<1.5 
                continue
            elseif V > 2.5
                continue
            end
            b = (1.1428 - 0.996 ./ V).^2;

            dV  = gradient(V, lambda_m);
            d2V = gradient(dV, lambda_m);
            db_dV    = gradient(b, V);
            d2b_dV2  = gradient(db_dV, V);

            d2b_dl2 = d2b_dV2 .* (dV.^2) + db_dV .* d2V;

            D_waveguide = -(lambda_m ./ c) .* (n2 * Delta) .* d2b_dl2 * 1e6;
            D_w_1550 = interp1(lambda_m, D_waveguide, lambda0);

            % Total dispersion
            D_total = D_w_1550 + D_mat_1550;

            % Store everything
            results = [results; a, n2, Delta, D_w_1550, D_total];

        end
    end
end

% Find best (minimum |D_total|)
[~, idxBest] = min(abs(results(:,5)));
best = results(idxBest,:);

best_a     = best(1);
best_n2    = best(2);
best_Delta = best(3);
best_Dw    = best(4);
best_Dt    = best(5);

% Compute best n1, NA, V
best_n1 = best_n2 / sqrt(1 - 2*best_Delta);
NA = sqrt(best_n1^2 - best_n2^2);
V_number = (2*pi*best_a/lambda0)*NA;

% Print results
fprintf("\n=== Best Solution (Minimum |Total Dispersion|) ===\n");
fprintf("Core radius a       = %.3f µm\n", best_a*1e6);
fprintf("Cladding index n2   = %.6f\n", best_n2);
fprintf("Core index n1       = %.6f\n", best_n1);
fprintf("Delta               = %.6f\n", best_Delta);
fprintf("Numerical Aperture  = %.6f\n", NA);
fprintf("V-number (1550 nm)  = %.3f\n", V_number);
fprintf("Waveguide Disp Dw   = %.3f ps/(nm·km)\n", best_Dw);
fprintf("Total Dispersion Dt = %.3f ps/(nm·km)\n", best_Dt);

%% Show first few entries
fprintf("\nSample of result table:\n");
fprintf("   a(µm)   n2      Delta      Dw        Dt\n");
for k = 1:25 % show the first 25 results
    fprintf("  %6.3f %6.3f  %7.4f   %8.3f   %8.3f\n", ...
        results(k,1)*1e6, results(k,2), results(k,3), results(k,4), results(k,5));
end