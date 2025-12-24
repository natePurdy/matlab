% compare_strategies.m
% Compare delay for two transmission strategies

clear; clc; close all;

% Parameters
P = 1000;          % bits per frame
N = 1;             % number of frames (scales linearly)
C = 0:50:5000;     % range of coding overhead values
q = linspace(0, 1, 500);  % range of corruption probabilities

% --- (a) Strategy 1: Error correcting code ---
D1 = N * (P + C);  % delay = N*(P + C)

% --- (b) Strategy 2: Retransmission ---
% To compare meaningfully, compute D2 for a range of q
q_star = C ./ (P + C);  % threshold probability where D1 = D2

% Plot
figure;
plot(C, q_star, 'LineWidth', 2);
grid on;
xlabel('Coding Overhead (C) [bits]');
ylabel('Equivalent Corruption Probability q^*');
title('Threshold q^* = C / (P + C) for Equal Delay');
legend('q^* = C / (P + C)', 'Location', 'southeast');

% Annotate regions
hold on;
text(1000, 0.2, 'Retransmission better', 'FontSize', 10, 'Color', 'b');
text(3000, 0.8, 'Error Correction better', 'FontSize', 10, 'Color', 'r');