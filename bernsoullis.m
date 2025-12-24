%bernoullia
clear;
close all;
n = 50;
k = 45;
p = 0.95;
q = 1-p;

totalP = 0;
for i=1:k-1

    % for right tail probability
    totalP = totalP + nchoosek(50,i)*p^i * q^(n-i);

end
% right tail using bernoullies trials which is dumb unless you have a for
% loop
disp("Result of bernoulli (*exact answer) - right tail")
rightTail = 1-totalP


% now compare to CLT approximation
z = (k - n*p)/(sqrt(n*p*q))

% Right-tail probability P(Z > z)
disp("Right side tail: P(Z>=z)")
p_tail = 1 - normcdf(z)

% left sided probability P(Z < z)
disp("Left side : P(Z<z)")
p_left = normcdf(z)

disp("Two side tail: P(|Z|>=z):")
p_tail2 = 2*(1 - normcdf(z))

