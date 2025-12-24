syms x
p = 2*x^2 + x-1;
r = root(p,x)
rVpa= vpa(r)
rVpa1 = rVpa(1)


% Plotting two functions and marking their intersection

% Define range for x
x = linspace(-2, 2, 400);

% Define functions
f1 = 1 - x;       % f1(x) = 1 - x
f2 = 2 * x.^2;    % f2(x) = 2x^2

% Find intersection points by solving 1 - x = 2x^2
syms xs
eq = 1 - xs == 2*xs^2;
sol = double(solve(eq, xs));

% Compute corresponding y-values
ys = 1 - sol;

% Plot the functions
figure;
plot(x, f1, 'b', 'LineWidth', 2); hold on;
plot(x, f2, 'r', 'LineWidth', 2);

% Plot intersection points
plot(sol, ys, 'ko', 'MarkerFaceColor', 'g', 'MarkerSize', 8);

% Labeling
legend('f_1(x) = 1 - x', 'f_2(x) = 2x^2', 'Intersection point(s)', 'Location', 'best');
xlabel('x');
ylabel('y');
title('Intersection of f_1(x) = 1 - x and f_2(x) = 2x^2');
grid on;

% Display intersection points in command window
disp('Intersection points (x, y):');
disp([sol ys]);