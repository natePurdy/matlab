% Unit-step function defined as 0 for input argument values
% less than zero, 1/2 for input argument values equal to zero,
% and 1 for input argument values greater than zero. This
% function uses the sign function to implement the unit-step
% function. Therefore value at t = 0 is defined. This avoids
% having undefined values during the execution of a program
% that uses it.
%
% function y = us(x)
%
function y = us(x)
y = (sign(x) + 1)/2 ;