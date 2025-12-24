% Consider the random process
syms f t tau x y sigma_squared

% Define the mean and variance
ux = 0; uy = 0;
varX = sigma_squared; 
varY = sigma_squared;

% Define the Gaussian PDFs of X and Y
fx_x = (1/sqrt(2*pi*sigma_squared)) * exp(-(x-ux)^2/(2*sigma_squared));
fy_y = (1/sqrt(2*pi*sigma_squared)) * exp(-(y-uy)^2/(2*sigma_squared));

% Define the random process W(t)
% Note: X and Y are random variables, we use symbolic placeholders X and Y
syms X Y
W_t   = X*cos(2*pi*f*t) + Y*sin(2*pi*f*t);
W_t_tau = X*cos(2*pi*f*(t+tau)) + Y*sin(2*pi*f*(t+tau));

% Compute W(t) * W(t+tau)
product = expand(W_t * W_t_tau);
product = simplify(product);

% Take expectation using the properties of Gaussian RVs:
% E[X^2] = sigma_squared, E[Y^2] = sigma_squared, E[XY] = 0
R_W_tau = subs(product, [X^2, Y^2, X*Y], [sigma_squared, sigma_squared, 0]);
R_W_tau = simplify(R_W_tau)

disp('Autocorrelation function R_W(tau):')
disp(R_W_tau)