clear; clc;
syms t w a b c
% a, b and c are variables of the dirac function

R = c*dirac(t - a);        % random process with gain c
% b = 0; % offset of random process
f = exp(-1j*w*t);            % Fourier kernel

% Compute the FT of each term separately
FT_delta = int(R*f, t, -inf, inf);   % gives exp(-i*w*a)
FT_const = 2*pi*b*dirac(w);                     % FT{b} = 2π b δ(w)

result = FT_delta + FT_const;

disp('Generalized dirac Fourier transform result:')
disp(result)