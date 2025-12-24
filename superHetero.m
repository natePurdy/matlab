% Simple Radar signal processing system (superheterodyne radar reciever)



% time for plotting in time 
t = 0:0.1:1000;
%angles for plotting in angle?
angles = -1*2*pi:0.01:2*pi;

%----------- carrier signal ( FOR AMPLITUDE MODULATION )---------------%
%carrier frequency
fc = 20000; %Hz
Ac = 50;
Carrier = Ac.*sin(2*pi*fc*t);
%----------- END carrier signal ---------------%


%----------- Radar Signal ---------------%
%radar frequency
fr = 700; % Hz

% phase modulation(PM) function. Extract for velocity
% ----for CW or constant PRF, p_mod is constant----
p_mod = 0;
Ar = 1;
Rsig = Ar.*cos(2*pi*fr*t + p_mod);

% input signal 
input = Carrier.*Rsig;
plot(t,Carrier)

plot(t,Rsig)

plot(t,input)

% RF