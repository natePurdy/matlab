clear; clc;

% Define symbolic variable
syms x

% --- Define your function here ---
% Example: f(x) = 0.0798 * exp(-x^2 / 50)
f = 0.0798 * exp(-x^2 / 50);

% Display the function
disp('Function to integrate:');
pretty(f)

% --- Choose integration type ---
% Set bounds here (leave empty for indefinite integral)
a = [-inf];   % Lower bound (e.g., -inf or -5)
b = [inf];   % Upper bound (e.g., inf or 5)

% Compute the integral
if isempty(a) || isempty(b)
    % Indefinite integral
    F = int(f, x);
    disp('Indefinite Integral:');
    pretty(F)
else
    % Definite integral from a to b
    F = int(f, x, a, b);
    fprintf('Definite Integral from %.2f to %.2f:\n', a, b);
    disp(vpa(F, 6))  % Show result to 6 significant digits
end