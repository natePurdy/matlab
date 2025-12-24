% Define grid
dx = 0.001;                      % Step size
x = 0:dx:1;                      % Range for uniform(0,1)
fx = ones(size(x));              % Uniform PDF (height = 1 on [0,1])

% Convolve the two PDFs
fz = conv(fx, fx) * dx;          % Multiply by dx to preserve area

% Define corresponding z-values
z = 0:dx:(2);                    % Range of sum (0 to 2)

% Plot
figure;
plot(z, fz, 'LineWidth', 2);
xlabel('z');
ylabel('f_Z(z)');
title('PDF of Z = X + Y (Sum of Two Uniform(0,1) RVs)');
grid on;