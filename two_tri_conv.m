% Program to do a discrete-time approximation of the
% convolution of two unit triangles
% Convolution computations
Ts = 0.01; % Time between samples
nx = [-100:99] ; nh = nx ; % Discrete time vectors for
 % x and h
x = tri(nx*Ts) ; h = tri(nh*Ts) ; % Generate x and h
ny = [nx(1)+nh(1):nx(end)+nh(end)]; % Discrete time vector for y
y = Ts*conv(x,h) ; % Form y by convolving x and h
% Graphing and annotation
p = plot(ny*Ts,y,'k') ; set(p,'LineWidth',2); grid on ;
xlabel('Time, {\itt} (s)','FontName','Times','FontSize',18) ;
ylabel('y({\itt})','FontName','Times','FontSize',18) ;
title('Convolution of Two Unshifted Unit Triangle Functions',...
'FontName','Times','FontSize',18);
set(gca,'FontName','Times','FontSize',14);