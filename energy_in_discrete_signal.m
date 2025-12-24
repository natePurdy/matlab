% Program to compute the signal energy or power of some example signals
% (a)
n = -100:100 ; % Set up a vector of discrete times at
 % which to compute the value of the
 % function
% Compute the value of the function and its square
x = (0.9).^abs(n).*sin(2*pi*n/4) ; xsq = x.^2 ;
Ex = sum(xsq) ; % Use the sum function in MATLAB to
 % find the total energy and display
 % the result.
disp(['(b) Ex = ',num2str(Ex)]);
% (b)

N0 = 35; % The fundamental period is 35
n = 0:N0-1; % Set up a vector of discrete times
 % over one period at which to compute
 % the value of the function
% Compute the value of the function and its square
x = 4*impND(5,n) - 7*impND(7,n) ; xsq = x.^2 ;
Px = sum(xsq)/N0; % Use the sum function in MATLAB to
 % find the average power and display
 % the result.
disp(['(d) Px = ',num2str(Px)]);