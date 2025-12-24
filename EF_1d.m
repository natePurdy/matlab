% Waveform Antenna Parameters %
N = 10;
lambda = 0.002;
d = lambda/2;
theta = -pi/2:0.0001:pi/2;
theta_naught =pi/4;
e_naught = 1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% electric field intensity equation
E = sin((N*pi*d/lambda).*(sin(theta)-sin(theta_naught)))./ ...
    sin((pi*d/lambda).*(sin(theta)-sin(theta_naught)))
E = abs(E)
% convert to degrees for plotting
theta = theta.*180/pi;
figure
plot(theta,E)
title('Electric Field Intensity |E(theta)| ')


xlabel('Angle off Boresight')
ylabel('|E|')
