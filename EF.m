

% Waveform Antenna Parameters %
N = 100;
d = 0.0002;
lambda = 0.6;
[x,y] = meshgrid(-1*pi/2:0.1:pi/2);
theta = sqrt(x.^2 + y.^2) + eps;
theta_naught =-pi/4;
e_naught = 1;
j = sqrt(-1);
E = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% electric field intensity equation
E = abs(sin(N*(pi*d/lambda).*(sin(theta)-sin(theta_naught)))./ ...
    sin(pi*d/lambda).*(sin(theta)-sin(theta_naught)))
% one dimension
theta_dumb = -1*pi/2:0.1:pi/2;
e_dumb = abs(sin(N*(pi*d/lambda).*(sin(theta_dumb)-sin(theta_naught)))./ ...
    sin(pi*d/lambda).*(sin(theta_dumb)-sin(theta_naught)))
plot(theta,e_dumb)

% convert to degrees for plotting
theta = theta.*180/pi;
figure
surf(x,y,E)
title('Electric Field Intensity |E(theta)| ')

zlabel('|E|')
xlabel('Angle off Boresight x')
ylabel('Angle off Boresight y')
