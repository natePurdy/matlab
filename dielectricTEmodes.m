close all;
% Parameters
delta = 0.0018;
m = 0;

% Range for b (avoid 0 and 1 to prevent singularities)
b = linspace(0.0001, 0.9999, 1000);

% Calculate V for each b using the rearranged equation
theta1 = atan(sqrt(b ./ (1 - b)));
theta2 = atan(sqrt((b + delta) ./ (1 - b)));
V = 0.5 * (m * pi + theta1 + theta2) ./ sqrt(1 - b);

% Plot V vs. b
figure;
plot(V, b, 'b', 'LineWidth', 2);
xlabel('Normalized frequency V');
ylabel('Normalized propagation constant b');
title('TE Mode Dispersion Curve (Asymmetric Slab)');
grid on;
xlim([min(V), max(V)]);
ylim([0, 1]);


% Highlight solution for V = 0.1167
V_target = 0.1167;

% Interpolate to find approximate b at that V
b_target = interp1(V, b, V_target);

hold on;
plot(V_target, b_target, 'ro', 'MarkerSize', 8, 'LineWidth', 2);
text(V_target, b_target + 0.02, sprintf('b ≈ %.4f', b_target), 'Color', 'r');

fprintf('Approximate b for V = %.4f is b ≈ %.5f\n', V_target, b_target);