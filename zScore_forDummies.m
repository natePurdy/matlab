% tail_probability.m
% Calculate the right-tail probability for a given z-score
mean = 96;
stdDev = 10;
Y = 116;
z = (Y-mean)/stdDev;   % your z-score

% Right-tail probability P(Z > z)
disp("Right side tail: P(Z>=z)")
p_tail = 1 - normcdf(z)

% left sided probability P(Z < z)
disp("Left side : P(Z<z)")
p_left = normcdf(z)

disp("Two side tail: P(|Z|>=z):")
p_tail2 = 2*(1 - normcdf(z))