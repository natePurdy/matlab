% ECE 538 project 2

% This project is about simulating a recieved radar datset of W-Band radar system
% - uses LFM waveform with STRETCH PROCESSING
% 
% Center frequency: 77GHz
% Sweep frequency: 76.8GHz-77.2GHz
% Pulse width: 20𝜇𝑠
% PRI: 30𝜇𝑠
% Fast time sample/chirp: 400
% Number of chirps: 500
% Fast time sampling frequency: 20MHz


%% ~~~~~~~~~~~~~~~~~~ GIVEN CODE FOR DATA GENERATION
clear;
close all;

f_c=77e9; % center frequency
f_start=76.8e9;% chirp starting frequency
f_stop=77.2e9;% chirp end frequency
PRI=30e-6;%Pulse Repetition Interval
P_T=20e-6; %chirp pulse width
M=400; % fast time samples
K=500; % number of chirps
f_s=20e6; % ADC sample frequency
c=3e8; % light speed
dt=1/f_s;
thermal_noise_power=0; % thermal noise power

R=[10;100]; % target range
v=[15;10]; % target velocity
RCS=[1;10000]; % target RCS

% generate noise for data cube
thermal_noise=normrnd(0,1,M,K)+1i.*normrnd(0,1,M,K);
thermal_noise=thermal_noise*sqrt(thermal_noise_power);
scatter(axes1,t/tau,real(og_chirp),".", "red")
title(axes1,"Real valued LFM UpChirp Waveform")
ylabel(axes1,"Amplitude")
xlabel(axes1,"norm time t/tau ")
% compute range frequency of each target return
f_r=2*R/c*(f_start-f_stop)/P_T;

% compute doppler frequency of each target return
f_d=2*v*f_c/c;

% PRI length in samples
pri_len = round(PRI*f_s);

% compute amplitude of target return
%   Pr = (Pt*G^2*lambda^2*RCS)/((4*pi)^3*R^4)
%
% equation assumes:
%   (Pt*G^2*lambda^2)/((4*pi)^3) = 1
%
RCS=sqrt(RCS);
amp=((RCS)./R.^2);

% time axis for a pulse (s)
t_pulse=dt*(0:(pri_len-1));

% time axis for a cpi (s)
t_cpi=dt*(0:(pri_len*K-1));

% compute return of target due to range effects only
% repeats each pulse due to indentical transmit signal
rec1 = repmat(exp(1i*2*pi*f_r.*t_pulse),1,K);

% compute doppler shift of each target return
% complex exponential operates over full CPI
% produce doppler shift and range-doppler coupling
rec2 = exp(1i*2*pi*f_d.*t_cpi);

% compute overall return using superposition of each target return
rec3 = sum(amp.*rec1.*rec2,1);

% compute data cube due to signal returns only
received = reshape(rec3,pri_len,K);
received = received(1:M,:);

% compute total received data cube (signal + noise)
data_cube=received+thermal_noise;
%%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ (40 points) Question #1:
% In the simulation, set the thermal noise power to 0, and set two targets as below:
% R=[10,100]';
% v=[15,10]';
% RCS=[1,10000]';
% Do range compression ⇒ doppler compression. Show the range-doppler figure you generated.
% Compare the amplitude between two targets in the range-doppler domain.