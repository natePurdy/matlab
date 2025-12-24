function plot_gaussian(mu, sigma, plot_type)
    % close all;

    % plot_gaussian(mu, sigma, plot_type)
    % Plots the PDF, CDF, or a custom function and its integral
    % Inputs:
    %   mu        - mean of the distribution
    %   sigma     - standard deviation (must be > 0)
    %   plot_type - 'pdf', 'cdf', or 'custom_integral'

    % Validate standard deviation
    if sigma <= 0
        error('Standard deviation must be positive.');
    end

    % Validate plot_type
    if ~ismember(lower(plot_type), {'pdf', 'cdf', 'custom_integral'})
        error('plot_type must be ''pdf'', ''cdf'', or ''custom_integral''.');
    end

    % Generate x values centered around the mean
    x = linspace(mu - 4*sigma, mu + 4*sigma, 1000);

    switch lower(plot_type)
        case 'pdf'
            y = (1 / (sigma * sqrt(2*pi))) * exp(-0.5 * ((x - mu) / sigma).^2);
            y_label = 'PDF';
            plot_title = sprintf('Gaussian PDF (\\mu = %.2f, \\sigma = %.2f)', mu, sigma);

            % Plot
            figure;
            plot(x, y, 'b-', 'LineWidth', 2);
            grid on;
            xlabel('x');
            ylabel(y_label);
            title(plot_title);
            legend(upper(plot_type));

        case 'cdf'
            y = 0.5 * (1 + erf((x - mu) / (sigma * sqrt(2))));
            y_label = 'CDF';
            plot_title = sprintf('Gaussian CDF (\\mu = %.2f, \\sigma = %.2f)', mu, sigma);

            % Plot
            figure;
            plot(x, y, 'r-', 'LineWidth', 2);
            grid on;
            xlabel('x');
            ylabel(y_label);
            title(plot_title);
            legend(upper(plot_type));

        case 'custom_integral'
            % Define the function f(x) = 0.0798 * exp(-x^2 / 50)
            fx = 0.0798 * exp(-x.^2 / 50);

            % Compute the integral F(x) ≈ 0.5001 * erf(x / (5*sqrt(2)))
            Fx = 0.5001 * erf(x / (5 * sqrt(2)));

            % Plot both the function and its integral
            figure;
            plot(x, fx, 'b-', 'LineWidth', 2); hold on;
            plot(x, Fx, 'r--', 'LineWidth', 2);
            grid on;
            xlabel('x');
            ylabel('Function Value');
            title('Function and Integral: 0.0798e^{-x^2 / 50}');
            legend('f(x) = 0.0798e^{-x^2/50}', 'Integral of f(x)');
    end
end