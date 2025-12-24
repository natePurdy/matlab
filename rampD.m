% integer argument values equal to or less than zero, and
% “n” for input integer argument values greater than zero.
% Returns “NaN” for non-integer arguments.
%
% function y = rampD(n)
function y = rampD(n)
y = ramp(n); % Use the continuous-time ramp
I = find(round(n) ~= n); % Index non-integer values of n
y(I) = NaN; % Set those return values to NaN