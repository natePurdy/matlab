

% electric field intensity (in Watts im guessing)equation that my teacher had in class notes but
% that i cant find i the textbook (yet)
eNaught = 1; % not really sure what this one is
N = 100; % number of individual anntennas on array
angle = -2*pi:pi/10:2*pi; % phase of carrier signal ()
theta_naught = 80*pi/180; % offset for phase array stearing (in radians)
d = 0.01; % distance between antenna
lambda = 0.001; % wavelength in meters


% resolution
%plot(theta, sin(angle)/angle)
plot(angle, eNaught*(sin(N*(pi*d/lambda))*(sin(angle)-sin(theta_naught)))./(sin(pi*d/lambda)*(sin(angle)-sin(theta_naught))))
%plot(angle, calcu(eNaught,N,angle,theta_naught,d,lambda))

function [EF_intensity] = calcu(eNaught,N,angle,theta_naught,d,lambda)
EF_intensity = eNaught*(sin(N*(pi*d/lambda))*(sin(angle)-sin(theta_naught)))./(sin(pi*d/lambda)*(sin(angle)-sin(theta_naught)))

end