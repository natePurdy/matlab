% Function to generate the discrete-time impulse
% function defined as one for input integer arguments
% equal to zero and zero otherwise. Returns “NaN” for
% non-integer arguments.
%
% function y = impD(n)
%
function y = impD(n)
 y = double(n == 0); % Impulse is one where argument
% is zero and zero otherwise
I = find(round(n) ~= n); % Index non-integer values of n
y(I) = NaN; % Set those return values to NaN