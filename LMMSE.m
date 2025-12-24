%% MMSE vs LMMSE Example
clear; close all; clc;
syms x y positive

%% Define PDFs
fxx = x*exp(-x);             % pdf of X, x >= 0
fy_given_x = 1/x;            % pdf of Y|X, uniform on [0, x]

xstart = 0; xend = inf;      % conditional support for X|Y=y
ystart = 0; yend = x;      

xa = 0 ; xb = inf;  % individual limits
ya = 0; yb = inf;   % individual limits

% where does x start and stop
YMargStart = y; YMargEnd = inf; % marginal fyy will need differetn limits  
XMargStart = 0; XMargEnd = inf;

%% Compute  joint pdf then f_Y(y)
jointPDF = fy_given_x * fxx       % f(x,y) = f(y|x)*f(x)
fyy = int(jointPDF, x, YMargStart, YMargEnd)
fyy = simplify(fyy);
disp('pdf of y is:')
disp(fyy)

%% Conditional pdf f_{X|Y}(x|y)
fx_given_y = simplify(jointPDF / fyy);
disp('pdf of x conditioned on y:')
disp(fx_given_y)

%% MMSE estimator: E[X|Y=y]
mmse_integrand = x * fx_given_y;
X_mmse = int(mmse_integrand, x, xstart, xend);
X_mmse = simplify(X_mmse);
disp('MMSE estimator E[X|Y=y] is:')
disp(X_mmse)

%% Compute needed expectations for LMMSE
% E[Y] = ∫ y f_Y(y) dy
EY = int(y*fyy, y, ya, yb);
EY = simplify(EY);
disp('E[Y] =')
disp(EY)

% E[X] = ∫ x f_X(x) dx
EX = int(x*fxx, x, xa, xb);
EX = simplify(EX);
disp('E[X] =')
pretty(EX)

% E[XY] = ∬ x*y*f(x,y) dx dy
E_XY = int(int(x*y*jointPDF, y, ystart, yend), x, xstart, xend);
E_XY = simplify(E_XY);
disp('E[XY] =')
pretty(E_XY)

% E[Y^2] = ∫ y^2 f_Y(y) dy
E_Y2 = int(y^2*fyy, y, ya, yb);
E_Y2 = simplify(E_Y2);
disp('E[Y^2] =')
pretty(E_Y2)

%% LMMSE
var_Y = simplify(E_Y2 - EY^2)
cov_XY = simplify(E_XY - EX*EY)

lmmse = simplify(EX + (cov_XY/var_Y)*(y - EY));
disp('LMMSE estimator is:')
pretty(lmmse)