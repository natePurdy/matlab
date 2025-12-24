% opticsHW4 help

% question 1 - simple step index fiber
n1 = 1.447; n2 = 1.446;
a = 4.5e-6; 

cutoffWavelength = 2*pi*a*sqrt(n1^2-n2^2)/2.4048

% operating wavelength if V = 6
opWavelength = 2*pi*a*sqrt(n1^2-n2^2)/6

%% problem 2
n2 = 1.447; delta = 0.003;
a = 4.3e-6;

% calculate the domain of single mode operation
n1 = n2/(1-delta)
cutoffWavelength = 2*pi*a*sqrt(n1^2-n2^2)/2.4048
opWavelength = 2*pi*a*sqrt(n1^2-n2^2)/2
% estimate b from generalized b-V curve
b = 0.45; % if V = 2, b = 0.5 (single mode)
k_o = 2*pi/opWavelength;
beta = sqrt((b*(n1^2-n2^2)+n2^2)*k_o^2)
% at 1.55 um
waveLength = 1.55e-6;
Vnum = (2*pi/waveLength*a)*sqrt(n1^2-n2^2)
b = 0.4; % estimaite b from generalize b-V curve, gives new k_o
k_o = 2*pi/waveLength
beta = sqrt((b*(n1^2-n2^2)+n2^2)*k_o^2)
% spot size and confinement factor
waveLength1 = 1300e-9; waveLength2 = 1550e-9;
Vnum1 = ((2*pi/waveLength1)*a)*sqrt(n1^2-n2^2)
Vnum2 = ((2*pi/waveLength2)*a)*sqrt(n1^2-n2^2)
spotSize1 = a*(0.65 + 1.619*Vnum1^(-3/2) + 2.879*Vnum1^(-6))
spotSize2 = a*(0.65 + 1.619*Vnum2^(-3/2) + 2.879*Vnum2^(-6))
aw1 = 1/(spotSize1/a)
aw2 = 1/(spotSize2/a)
%confinement factor
CF1 = 1-exp(-2*(aw1)^2)
CF2 = 1-exp(-2*(aw2)^2)

%% question 3: 2 fibers next to eachother in cladding
a = 4e-6; %radius
waveL = 1550e-9;
n1 = 1.460; n2 = 1.453; % core ; cladding refr index
% what is V mode of each fiber 
V1 = (2*pi/waveL*a)*sqrt(n1^2-n2^2)
V2 = V1
waveL2 = 1310e-9;
vmod1 = (2*pi/waveL2*a)*sqrt(n1^2-n2^2)

% plotting the power transfer between the two
% Parameters
P0 = 1;               % Initial power (normalized to 1)
L0 = 1;               % Coupling length (arbitrary units)
z = linspace(0, 4*L0, 1000);  % Propagation distance from 0 to 4*L0

% Power equations
P1 = P0 * cos(pi * z / (2*L0)).^2;  % Power in core 1
P2 = P0 * sin(pi * z / (2*L0)).^2;  % Power in core 2

% Plot
figure;
plot(z, P1, 'b-', 'LineWidth', 2); hold on;
plot(z, P2, 'r--', 'LineWidth', 2);
xlabel('Propagation Distance z');
ylabel('Power');
title('Power Transfer Between Two Coupled Optical Fibers');
legend('Core 1 (P_1)', 'Core 2 (P_2)', 'Location', 'best');
grid on;
xlim([0 4*L0]);
ylim([0 P0 + 0.1]);

% Add vertical lines for multiples of L0
for k = 1:3
    xline(k*L0, 'k--', ['z = ' num2str(k) 'L_0'], ...
        'LabelVerticalAlignment', 'bottom', 'LabelHorizontalAlignment', 'center');
end

%% question 4: sstep fiber
n1 = 1.444; n2 = 1.443;
waveL = 1.55e-6; Vnum = 10;
% find radius
a = Vnum*waveL/(2*pi*sqrt(n1^2-n2^2))

% if V = 4
b = 0.77; % approximate b from normalized b-V plot
k_o = 2*pi/waveL
beta = sqrt((b*(n1^2-n2^2)+n2^2)*k_o^2)
phaseVel = 3e8/n1

%% question 5 
fiberLength = 1000; % 1km
halfLength = fiberLength/2;% 2 segments of fiber
GVD = 20; %ps/km-nm
Ny = 1.463; Nx = 1.462;
% differential group delay =
DGD = abs(Ny-Nx)*halfLength/(3e8)
