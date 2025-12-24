%Homework 2


% problem 1 
%Parameters
ft = 95e9; %Hz
Pt_linear = 100; % Watts
beam_az = 2; % Degrees
beam_el = 5 ;
system_loss = 5; %dB
RCS = 20; %m^2
Range = 3000; % meters
atmos_atten = 0.4*6 + 15*6  %dB*km (recall 2 way travel)
La_linear = 10^(atmos_atten/10) 
Ls_linear = 10^(system_loss/10)
wavelength = 3e8/ft %meters

% linear conversion of units that are in dedibels
atmos_atten = 10^(atmos_atten/10) % watts
system_loss = 10^(system_loss/10) % watts

%% gain factor
G = 26000/(beam_az*beam_el)

Pr_linear = (Pt*(G^2)*(wavelength^2)*RCS)/(((4*pi)^3)*La_linear*Ls_linear*Range^4)
10*log10(Pr_linear)
10*log10(Pt)
% ----- problem 24
vt2south = -100*sin(pi/4)
vt2west = -1*vt2south
vt1north = 100

Vradial = vt1north - vt2south




%problem 25
theta = 0:0.01:pi;
vradial = 200*cos(theta);

plot(theta,vradial)
% 
