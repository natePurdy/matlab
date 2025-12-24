% Symbolic Integral Solver Script

% Clear workspace and command window
clear;
clc;

% Define symbolic variables
syms x y

% === User Input Section ===

% Define the integrand 
f = x^2 ;

% Set variable of integration: 'x' or 'y'
var = y;

% Set the limits of integration
% These can be symbolic (like sqrt(y)) or numeric (like 0 or 1)
lower_limit = 0;   % try also: 0
upper_limit = 1/4;

% === End of User Input ===

% Perform the symbolic integration
F = int(f, var, lower_limit, upper_limit);

% Simplify the result
F_simplified = simplify(F);

% Display the results
disp('Symbolic Integral Result:');
pretty(F)

disp('Simplified Result:');
pretty(F_simplified)