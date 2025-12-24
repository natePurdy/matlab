%% hw6_gain_analysis.m
% Computes small-signal gain, saturation power, and max output power
% for three amplifier gain curves.

clear; clc; close all;

%% Input Data
x = [-30 -25 -20 -15 -10 -5 0 5];  % Input power (dBm)

y1 = [-6.5 -2 3.5 8 13.5 16.5 19 21];  % 1565 nm
y2 = [2 6 11 14 17 18.5 21 22];        % 1550 nm
y3 = [12 14 16.5 18.5 19 20 20.5 21.5];% 1530 nm

%% Interpolation
xq = linspace(min(x), max(x), 500);   % smooth curve

yq1 = interp1(x, y1, xq, 'linear');
yq2 = interp1(x, y2, xq, 'linear');
yq3 = interp1(x, y3, xq, 'linear');

%% ---- ANALYSIS FOR EACH WAVELENGTH ----
result1 = analyze_curve(xq, yq1);
result2 = analyze_curve(xq, yq2);
result3 = analyze_curve(xq, yq3);

%% Print Results
fprintf("\n===== RESULTS =====\n");

print_results("1565 nm", result1);
print_results("1550 nm", result2);
print_results("1530 nm", result3);

%% ----- PLOT -----
figure; hold on;

plot(xq, yq1, 'b-', 'LineWidth', 2);
plot(xq, yq2, 'r-', 'LineWidth', 2);
plot(xq, yq3, 'g-', 'LineWidth', 2);

% Mark saturation points
plot(result1.Psat_in, result1.Psat_out, 'bo', 'MarkerSize',8,'LineWidth',2);
plot(result2.Psat_in, result2.Psat_out, 'ro', 'MarkerSize',8,'LineWidth',2);
plot(result3.Psat_in, result3.Psat_out, 'go', 'MarkerSize',8,'LineWidth',2);

grid on;
title('Amplifier Gain Curves with Gain/Saturation Points');
xlabel('Input Power (dBm)');
ylabel('Output Power (dBm)');
legend("1565 nm", "1550 nm", "1530 nm", ...
       "Sat 1565", "Sat 1550", "Sat 1530", ...
       'Location','NorthWest');

%% -------- FUNCTIONS ---------

function result = analyze_curve(xq, yq)
    % Small-signal gain (first point)
    Pin_small = xq(1);
    Pout_small = yq(1);
    G_small = Pout_small - Pin_small;

    % Saturated gain (3 dB down)
    G_sat = G_small - 3;

    % Build the target output curve corresponding to G_sat
    y_target = xq + G_sat;

    % Find intersection with actual output curve
    [~, idx] = min(abs(yq - y_target));

    Psat_in = xq(idx);
    Psat_out = yq(idx);

    % Max output
    P_max = max(yq);

    result.G_small = G_small;
    result.G_sat = G_sat;
    result.Psat_in = Psat_in;
    result.Psat_out = Psat_out;
    result.P_max = P_max;
end

function print_results(label, R)
    fprintf("\n---- %s ----\n", label);
    fprintf("Small-signal gain:      %.2f dB\n", R.G_small);
    fprintf("Saturated gain:         %.2f dB  (3 dB down)\n", R.G_sat);
    fprintf("Saturation input power: %.2f dBm\n", R.Psat_in);
    fprintf("Saturation output:      %.2f dBm\n", R.Psat_out);
    fprintf("Maximum output power:   %.2f dBm\n", R.P_max);
end


% estimated output power per channelf or 8 16 and 40 wavelenght channels
% assume input power per channel is 10 uW
gainPerChannel = 10*log10(10e-6/1e-3)
gain8waves = 10*log10(8*10e-6/1e-3) - gainPerChannel
gain16waves = 10*log10(16*10e-6/1e-3) - gainPerChannel
gain40waves = 10*log10(40*10e-6/1e-3) - gainPerChannel

% power per channel
channel1 = 21-gain8waves
channel2 = 21-gain16waves
channel3 = 21-gain40waves