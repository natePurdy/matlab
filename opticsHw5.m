% Optics HW 5 — CORRECT SCRIPT (material + waveguide dispersion)
clc; clear; close all;

% ---------------  FIBER PARAMETERS  -----------------
n2 = 1.447;                    % cladding index
Delta = 0.00003;                 % relative index difference
a = 4e-6;                      % core radius [m]
lambda0 = 1.55e-6;             % target wavelength [m]
c = 3e8;                       % speed of light [m/s]

n1 = n2 / sqrt(1 - 2*Delta);   % core index


% ---------------  SELLMEIER (FUSED SILICA)  -----------------
B1 = 0.6961663;  C1 = (0.0684043)^2;
B2 = 0.4079426;  C2 = (0.1162414)^2;
B3 = 0.8974794;  C3 = (9.896161)^2;

% Wavelength grid
lambda_um = linspace(1.30, 1.60, 2000);
lambda_m  = lambda_um*1e-6;

% Silica refractive index
n_silica = sqrt(1 + B1*lambda_um.^2./(lambda_um.^2 - C1) + ...
                   B2*lambda_um.^2./(lambda_um.^2 - C2) + ...
                   B3*lambda_um.^2./(lambda_um.^2 - C3));


% ---------------  MATERIAL DISPERSION  -----------------
dn  = gradient(n_silica, lambda_m);
d2n = gradient(dn, lambda_m);

D_mat = -(lambda_m./c).*d2n * 1e6;          % ps/(nm·km)
D_mat_1550 = interp1(lambda_um, D_mat, 1.55);


% ---------------  DIRECT WAVEGUIDE DISPERSION  -----------------
% Normalized frequency V(λ)
% V num grid
% V(λ)
V = (2*pi*a ./ lambda_m) * sqrt(n1^2 - n2^2);
b = (1.1428 - 0.996 ./ V).^2;   % b(V(λ))
% db/dλ and d²b/dλ² via chain rule
dV  = gradient(V, lambda_m);
d2V = gradient(dV, lambda_m);
db_dV  = gradient(b, V);
d2b_dV2 = gradient(db_dV, V);

d2b_dl2 = d2b_dV2 .* (dV.^2) + db_dV .* d2V;

% Waveguide dispersion
D_waveguide = -(lambda_m ./ c) .* (n2*Delta) .* d2b_dl2 * 1e6;
D_waveguide_1550 = interp1(lambda_m, D_waveguide, 1.55e-6)

% --- Total dispersion ---
D_total = D_mat_1550 + D_waveguide_1550;

% --- Display results ---
fprintf('Results at λ = 1550 nm:\n');
fprintf('  n1 (core index)         = %.6f\n', n1);
fprintf('  n2 (cladding index)     = %.6f\n', n2);
fprintf('  Material dispersion Dm  = %.3f ps/(nm·km)\n', D_m_1550);
fprintf('  Waveguide dispersion Dw = %.3f ps/(nm·km)\n', D_w_1550);
fprintf('  Total dispersion Dt     = %.3f ps/(nm·km)\n', D_total);


%%%%%%%%% find where material dispersion is eaul to waveguide dispersion
%% (problem 2 - but use the sellmeieir result of problem 1)
lambda = 1550e-9;
V = 2
a = 0.45; % from nowmalized fiber v-b plot
d2beta = -D_m_1550*10e-6*(-c/lambda)*(V^2/lambda^2)
% d2betadlambda = 4*pi/(lambda^3)*sqrt(1.45n1^2-0.45n2^2)
% choose n2 = 1.5
n2 = 1.5;
n1 = sqrt( ( (((d2beta)*lambda^3 )/4*pi)^2  + 0.45*n2^2 )/1.45   )

%% peblmw 3
% diode mounted onto end of fiber 
n1 = 1.46; n2 = 1.455; nDiode = 3.5;
% find NA
NA = sqrt(n1^2-n2^2)
%find the coupling efficiency
thetaC_comp = acos(n2/n1)
thetaC_compDeg = acos(n2/n1)*180/pi
couplingEfficiency = NA^2
DiodeTheta_C = asin(1.46/3.5)
DiodeTheta_C_deg = asin(1.46/3.5)*180/pi



%%

% build a fiber line
% You need to build a 40Gb/s fiber link between two cities located ~50km apart. You decide to use
% the newly developed Vascade EX2000 fiber (see table below) to establish the link and a single
% laser working at 1550nm as the source. Assume that the 1 bits are unchirped Gaussian pulses with
% ~20ps FWHM duration at the beginning of the fiber link. Calculate the duration of the pulses at
% the end of the fiber link (you can ignore the nonlinear effects here).
% You realize that it is necessary to do dispersion compensation for the fiber link to achieve the
% required data rate. The simplest way is to add a spool of a dispersion compensating fiber at the end
% of the fiber link before the receiver to compensate for the dispersion of the 50km EX2000
% transmission fiber. From the table below, choose the appropriate dispersion compensating fiber.
% Calculate the length needed.
BW = 40e9; % b/s
distanceAB = 50e3; % 50 km
waveL = 1550e-9; % m
FWHM_inT = 20e-12; % s (20 ps)
c = 3e8;

% fiber parameters EX2000 ( main line)
dispersion = 20.4; % ps/nm/km
attenuation = 0.162; % dB/km
Aeff = 112; % (um)^2
Aeff = Aeff*1e-12; % convert to meters 
%fiber parameters for compensator line
dispersionComp = -38.0; % ps/(nm·km)


% conversions and calculations
FWHM_inF = 0.44 / FWHM_inT;                   % Hz
spectralBroadening = waveL^2 * FWHM_inF / c * 1e9;  % nm
dispersion = dispersion * 1e-12 / 1e3;         % s/(nm·m)
pulseBroadening = abs(dispersion) * spectralBroadening * distanceAB;  % s

% output total pulse width (assuming Gaussian)
FWHM_outT = sqrt(FWHM_inT^2 + pulseBroadening^2);

fprintf('Pulse broadening = %.3e s\n', pulseBroadening);
fprintf('Output FWHM = %.3e s\n', FWHM_outT);

%how to apply dispersion compensation to the fiber
% choose a type of dispersion fiber to use and the length needed.
% compensation fiber: vascade V1000
% Dispersion compensation fiber (e.g. Vascade V1000)
dispersionComp = dispersionComp * 1e-12 / 1e3 % s/(nm·m)

% Required compensation length
distanceToCompensate = - (dispersion * distanceAB) / dispersionComp;
fprintf('Compensation fiber length = %.2f km\n', distanceToCompensate / 1e3);


% Estimate the threshold power for stimulated Brillouin and stimulated Raman scattering
% for the fiber link in Problem 4 above (gB = 5*10-11 m/V at 1550nm, gR =10-13 m/V at 1550nm).
gR = 10^-13; % raman gain @ 1550 nm
gB = 5*10^-11; % brillouin gain @ 1550 nm, (m/v)
% first find attenuation coeeficient
attenCoeff = attenuation/4.343  % magic number comes from solving for attenuation coeefficienct assuming exponential decay function of P2/P1
% effective length
Le = (1-exp(-attenCoeff*50))/attenCoeff

% brilloin power threshold
Pth_brilloin = 21*Aeff/(gB*Le)
Pth_raman = 16*Aeff/(gR*Le)