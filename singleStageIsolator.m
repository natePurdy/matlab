clear; close all;

% single stage isolator
lambdaA = 1550e-9; % 1550 nm
% % % % % % % % % % % % % % % % % Consider a premium grade single stage isolator with the specifications as shown below.
% specifications given
typPeakIsolation = 42; % dB
minIsolation = 30; %dB
typInsertionLoss = 0.35; %dB
maxInsertionLoss = 0.5; %dB
% polarizationStates = ?
minReturnLoss_inputOverOuput = 60/55; % dB 
maxPolarizationDependentLoss = 0.05; %dB
maxPolarizationModeDispersion = 0.2; % ps
maxOpticalPowerCW = 300; %mW
maxTensileLoad = 5; %newton
fiberType = 'SMF-28';
% some specs about smf28 fiber (may or may not be usefull)
diameter = 8.3e-6;
NA = 0.13;
MFD = 10.4e-6; 
loss1550 = 0.19; % dB/km
dispersion = 17; %ps/nm*km
BGB = 50e6; %Hz

                                        % a) Assume we input 1mW of laser power (at 1550nm) at port A. What is the power we
                                        % should have at port B?

inputPower = 1; %mW
powerRatioPortAB = 10^(-typInsertionLoss/10)
powerOutPortAB = powerRatioPortAB*inputPower

                                        % b) Assume we input 1mW of laser power at port B. What is the power we should have at
                                        % port A
powerRatioPortBA = 10^(-typPeakIsolation/10)
powerOutPortBA = powerRatioPortBA*inputPower
