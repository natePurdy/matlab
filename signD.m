% Signum function defined as −1 for input integer argument
% values less than zero, +1 for input integer argument
% values greater than zero and zero for input argument values
% equal to zero. Returns “NaN” for non-integer arguments.
%
% function y = signD(n)
function y = signD(n)
y = sign(n); % Use the MATLAB sign function
I = find(round(n) ~= n); % Index non-integer values of n
y(I) = NaN; % Set those return values to NaN