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