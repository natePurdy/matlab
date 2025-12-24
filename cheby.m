% Define range of lambda (arrival rate)
lambda_vals = linspace(0.5, 5, 100);  % from 0.5 to 5
a = 3;  % threshold: we compute Pr(W >= a)
chebyshev_bounds = zeros(size(lambda_vals));
exact_probs = zeros(size(lambda_vals));

% Define numerical integration function for exact Pr(W >= a)
for i = 1:length(lambda_vals)
    lambda = lambda_vals(i);

    % Define PDF of W = XY when X, Y ~ Exp(lambda)
    f_W = @(w) 2 * lambda^2 * besselk(0, 2 * lambda * sqrt(w));

    % Compute exact probability: Pr(W >= a)
    exact_probs(i) = integral(f_W, a, Inf);

    % Compute mean and variance of W = XY
    mu = 1 / lambda;  % E[X] = 1/lambda
    sigma2 = 1 / lambda^2;  % Var[X] = 1/lambda^2
    E_W = mu^2;             % E[XY] = E[X]*E[Y]
    Var_W = sigma2^2 + mu^2 * sigma2 + sigma2 * mu^2; % Var[XY] using independence

    % Use Chebyshev: Pr(|W - E[W]| >= a - E[W]) <= Var(W) / (a - E[W])^2
    if a > E_W
        chebyshev_bounds(i) = Var_W / (a - E_W)^2;
    else
        chebyshev_bounds(i) = 1;  % trivial upper bound
    end
end

% Plotting
figure;
plot(lambda_vals, exact_probs, 'b-', 'LineWidth', 2); hold on;
plot(lambda_vals, chebyshev_bounds, 'r--', 'LineWidth', 2);
xlabel('\lambda (Arrival Rate)');
ylabel('P(W \geq a)');
title(sprintf('Exact vs Chebyshev Bound for P(W \\geq %d)', a));
legend('Exact Probability', 'Chebyshev Bound');
grid on;