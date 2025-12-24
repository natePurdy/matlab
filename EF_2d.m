
%---------- Beamstearing plus general waverform stuff----------%
% currently only "1d" version is rowking correctly
% Waveform Antenna Parameters %

% intital plot stearing angle
theta_naught_x =60*pi/180;
theta_naught_y =-60*pi/180;

list1 = {'15','30','45',...                   
'60','90','close'};
[indx,~] = listdlg('ListString',list1);
if indx == 1
    theta_naught_y = 15*pi/180;
end
if indx == 2
    theta_naught_y = 30*pi/180;
end
if indx == 3
    theta_naught_y = 45*pi/180;
end
if indx == 4
    theta_naught_y = 60*pi/180;
end
if indx == 5
    theta_naught_y = 90*pi/180;
end
if indx == 6
    return;
end
list1 = {'15','30','45',...                   
'60','90','close'};
[indx,tf] = listdlg('ListString',list1);
if indx == 1
    theta_naught_x = 15*pi/180;
end
if indx == 2
    theta_naught_x = 30*pi/180;
end
if indx == 3
    theta_naught_x = 45*pi/180;
end
if indx == 4
    theta_naught_x = 60*pi/180;
end
if indx == 5
    theta_naught_x = 90*pi/180;
end
if indx == 6
    return;
end

    
   

N = 10;
lambda = 0.002;
d = lambda/2;
[x,y] = meshgrid(-1*pi/2:0.05:pi/2);


e_naught = 1;
j = sqrt(-1);
E = 0;
% do forever
i = 1;
%-----------------------------------------%

% electric field intensity equation
Ex = sin((N*pi*d/lambda).*(sin(x)-sin(theta_naught_x)))./ ...
    sin((pi*d/lambda).*(sin(x)-sin(theta_naught_x)));
Ey = sin((N*pi*d/lambda).*(sin(y)-sin(theta_naught_y)))./ ...
    sin((pi*d/lambda).*(sin(y)-sin(theta_naught_y)));
E_total = Ex.*Ey;
%-----------------------------------------%
% convert to degrees for plotting
x = x*180/pi;
y = y*180/pi;
E_total = abs(E_total.^2); % convert to power
%-----------------------------------------%

% plot
figure
surf(x,y,E_total) 
zlabel('Power|E|^2')
xlabel('Angle off Boresight x')
ylabel('Angle off Boresight y')
