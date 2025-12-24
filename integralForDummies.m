% symbolic_integral_example.m
% This script computes a symbolic definite integral in MATLAB

% Define symbolic variables
syms x y

% Define the function to integrate
f = x-y;

% Define the limits of integration
a = 0;
b = 1;

% Compute the integral of f with respect to [dont forget to change these for the problems limits and integration variable]
I = int(f, y, a, b);

% Simplify the result (optional)
I_simplified = simplify(I);
% Display the result
disp('The symbolic integral is:')
disp(I_simplified)

% % outer integral also?
% f = I_simplified;
% % Define the limits of integration
% a = 0;
% b = x;
% % Compute the integral of f with respect to [dont forget to change these for the problems limits and integration variable]
% I = int(f, y, a, b);
% % Simplify the result (optional)
% I_simplified = simplify(I);
% % Display the result
% disp('The symbolic integral is:')
% disp(I_simplified)
