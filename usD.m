% Unit sequence function defined as 0 for input integer
% argument values less than zero, and 1 for input integer
% argument values equal to or greater than zero. Returns
% “NaN” for non-integer arguments.
%
% function y = usD(n)
%
function y = usD(n)
y = double(n >= 0); % Set output to one for non-
 % negative arguments
I = find(round(n) ~= n); % Index non-integer values of n
y(I) = NaN ; % Set those return values to NaN