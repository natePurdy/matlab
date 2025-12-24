syms V

% Define the function
f = (1.1428 - 0.996/V)^2;

% First derivative
df = diff(f, V)

% Second derivative
d2f = simplify(diff(df, V))


% Evaluate second derivative at V = 2
d2f_at_2 = subs(d2f, V, 2)
