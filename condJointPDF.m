% Clear figure and variables
clear;
clf;

% Create figure
figure;
hold on;
grid on;
axis equal;
title('Bounds of Joint PDF f_{X,Y}(x,y) and Event A: Y \leq 1/4', 'FontSize', 14);
xlabel('x', 'FontSize', 12);
ylabel('y', 'FontSize', 12);
axis([-1.2, 1.2, -0.05, 1.1]);

% Define x range
x = linspace(-1, 1, 500);
y_upper = x.^2;

% Plot the upper bound y = x^2
plot(x, y_upper, 'k', 'LineWidth', 2, 'DisplayName', 'y = x^2');

% Fill the support region of f_{X,Y}
fill_x = [x, fliplr(x)];
fill_y = [zeros(size(x)), fliplr(y_upper)];
fill(fill_x, fill_y, [0.8, 0.9, 1], 'EdgeColor', 'none', ...
     'DisplayName', 'Support of f_{X,Y}');

% Plot horizontal line y = 1/4 (event A boundary)
y_A = 0.25;
plot([-1, 1], [y_A, y_A], 'r--', 'LineWidth', 2, 'DisplayName', 'y = 1/4');

% Shade the event A region (Y <= 1/4 under y = x^2)
x_left  = linspace(-1, -0.5, 200);
x_mid   = linspace(-0.5, 0.5, 200);
x_right = linspace(0.5, 1, 200);

% Left and right: y in [0, 1/4]
for i = 1:length(x_left)
    fill([x_left(i), x_left(i)], [0, y_A], [1, 0.8, 0.8], 'EdgeColor', 'none');
end
for i = 1:length(x_right)
    fill([x_right(i), x_right(i)], [0, y_A], [1, 0.8, 0.8], 'EdgeColor', 'none');
end

% Middle: y in [0, x^2]
for i = 1:length(x_mid)
    y_val = x_mid(i)^2;
    if y_val <= y_A
        fill([x_mid(i), x_mid(i)], [0, y_val], [1, 0.8, 0.8], 'EdgeColor', 'none');
    else
        fill([x_mid(i), x_mid(i)], [0, y_A], [1, 0.8, 0.8], 'EdgeColor', 'none');
    end
end

% Add text annotations
text(-0.9, 0.6, 'Support: 0 \leq y \leq x^2', 'FontSize', 11);
text(-0.9, 0.3, 'Event A: Y \leq 1/4', 'FontSize', 11, 'Color', 'r');

% % Legend
% legend('Location', 'northwest');
% Add points x = +-sqrt(y_A) for y_A = 1/4
x_sqrt = sqrt(y_A);
plot([-x_sqrt, x_sqrt], [y_A, y_A], 'ko', 'MarkerFaceColor', 'k', ...
    'DisplayName', 'x = \pm\sqrt{y}');

% Label the points
text(-x_sqrt - 0.1, y_A + 0.02, '-\surd{y}', 'FontSize', 11);
text(x_sqrt + 0.02, y_A + 0.02, '+\surd{y}', 'FontSize', 11);
hold off;