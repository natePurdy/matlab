% Discrete-time periodic impulse function defined as 1 for
% input integer argument values equal to integer multiples
% of “N” and 0 otherwise. “N” must be a positive integer.
% Returns “NaN” for non-positive integer values.
%
% function y = impND(N,n)
function y = impND(N,n)
if N == round(N) && N > 0,
y = double(n/N == round(n/N)); % Set return values to one
 % at all values of n that are
 % integer multiples of N
I = find(round(n) ~= n); % Index non-integer values of n
y(I) = NaN; % Set those return values to NaN
else
y = NaN*n; % Return a vector of NaN’s
disp('In impND, the period parameter N is not a positive integer');
end
