% Clear workspace and figure
clear; clf;

% Define the vertices of the region
x = [0, 1, 0];
y = [0, 0, 1];

% Plot the filled region
fill(x, y, 'cyan', 'FaceAlpha', 0.5); % Semi-transparent fill
hold on;

% Plot the boundary lines
plot([0, 1], [1, 0], 'b--', 'LineWidth', 1.5); % Line x + y = 1
plot([0, 0], [0, 1], 'k-', 'LineWidth', 1);    % y-axis
plot([0, 1], [0, 0], 'k-', 'LineWidth', 1);    % x-axis

% Axis settings
axis equal;
axis([ -0.1 1.1 -0.1 1.1 ]);
xlabel('x');
ylabel('y');
title('Region defined by x + y \leq 1, x \geq 0, y \geq 0');

% Grid and legend
grid on;
legend('Feasible Region', 'x + y = 1', 'Location', 'northeast');