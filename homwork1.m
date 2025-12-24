%Homework 1

%1. The time delay to and from 3 targets are 1.5,1.8,and2.0 msec
%respectively

% a) find the range of these targets
% Given that R = c*t/2
c = 3*10^8;
t1 = 0.0015;
t2 = 0.0018;
t3 = 0.0020;
rng1 = c*t1/2
rng2 = c*t2/2
rng3 = c*t3/2


% The radar system needs to have a 50m range resolution
% what is the required approximate bandwidth

%nom_rng_res = c/(2*bw)
range_res = 50;
bw = c/(2*range_res)