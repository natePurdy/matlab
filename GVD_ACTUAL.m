clc;
clear all;
close all;


lm1 = 0.0684;
lm2 = 0.1162;
lm3 = 9.8962;
A1 = 0.69617;
A2 = 0.40794;
A3 = 0.89748;

lm = linspace(0.9,2.1,1200); % wavelength range in microns
%sellmeier eqn.
n = sqrt(1 + A1*(lm.^2./(lm.^2 - lm1^2))...
    + A2*(lm.^2./(lm.^2 - lm2^2))...
    +A3*(lm.^2./(lm.^2 - lm3^2))  );


figure(1)
plot(lm,n,'Linewidth',2)
ax = gca;
ax.FontSize = 16;
xlabel('Wavelength [\mum]','FontSize',18)
ylabel('Index n(\lambda)','FontSize',18)
title('Refractive Index of Fused Silica')
xlim([1 2])


c = 3e8*1e6; % speeds of light in micrometers per second

%second derivative of index of refrweaction with respect to wavelength
d2n = gradient(gradient(n,1e-3),1e-3);

gvd = (lm.^3).*d2n/(2*pi*c^2);
gvd = gvd * 1e30; % in units ps^2/km-nm

figure (2)
plot(lm,gvd*1000, 'LineWidth',2);
ax = gca;
ax.FontSize = 16;
xlabel('Wavelength [\mum]', 'FontSize', 18)
ylabel('GVD [ps^2/km', 'FontSize',18)
title('GVD of FUsed Silica')


% broadening of pulse
t0 = 100e-15;
[~,id ] = min((abs(lm-1.55)));   %2 find index of 1550 nm
gvd_1550 = 1e-24*gvd(id);
disp(gvd_1550)

z = 1e3; % ditance along waveguide

% result is in picoseconds
Ld = (t0^2)/(4*log(2)*abs(gvd_1550));
tf = t0*sqrt(1+(z/Ld)^2);
disp(tf/1e-12);