% WDM coupler:
        % Consider a fused WDM coupler with the specifications as shown below.

close all; clear;
% what are the two wavelengths into port A
operatingTolerance = 15e-9; % nm plus or minus around center wavelength
lambdaB = 980e-9; % 980 nm
lambdaC = 1550e-9; 

% now for some specs from the spec sheet
op1range = linspace(lambdaB-15e-9, lambdaB+15e-9, 2*operatingTolerance*1e9) % tolerance 
op2range = linspace(lambdaC-15e-9, lambdaC+15e-9, 2*operatingTolerance*1e9)
minIsolation = 20; %dB
maxInsertionLoss = 0.15; %dB
maxPolDepLoss = 0.1; %dB
thermalStabilityMax = 0.002; % dB/Celcius
minReturnLoss = 60; %dB
minDirectivity = 60; %dB
maxOpticalPowerCW = 300; %mW
operatingTempRange = linspace(-40,75);
storageTemperature = linspace(-40,75);
% COUPLER TOPOLOGY:
%                                                                      ,----------------------------------o   (Port B - 980 nm)
%                                                                     /
%      (Port A) o--------[     WDM COUPLER ] <-- splits
%    (980nm/1550nm)                                     \
%                                                                      '-----------------------------------o   (Port C - 1550 nm)
%               

% 1. Assume we input 1mW of 1550nm laser into port A.
% a) What is the minimum power we should have at port C?
inputPower = 1; %mW
% use the given insertion loss to solve for the power ratio between input and output
% insertionLoss = -10*log10(Pout/Pin)
% Pout/Pin = powerRatio
powerRatioPortC = 10^(-maxInsertionLoss/10)
powerOutPortC = powerRatioPortC*inputPower
% b) What is the maximum power we should have at port B?
% use the iola
powerRatioPortB = 10^(-minIsolation/10)
powerOutPortB = powerRatioPortB*inputPower

% 2. What is the power at port B and port C if we send 1 mW 1300 nm laser into port A?
% about 50-50, but maybe leaning towards one 
% 1300 nm input 
lambdaIn = 1300e-9;
deltaB = abs(lambdaIn - lambdaB);
deltaC = abs(lambdaIn - lambdaC);

% Weighting based on inverse distance
wB = (1/deltaB) / ((1/deltaB) + (1/deltaC));
wC = (1/deltaC) / ((1/deltaB) + (1/deltaC));

Pout_B = inputPower * wB;
Pout_C = inputPower * wC;

fprintf('1300 nm input:\n  Port B = %.3f mW\n  Port C = %.3f mW\n', Pout_B, Pout_C);