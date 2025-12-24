z = 1;
y = linspace(1e-4, 20, 100000);  % Avoid y = 0
dy = y(2) - y(1);

integrand = (1 ./ y) .* exp(-y - z ./ y);
fz = trapz(y, integrand);

plot(y, integrand), title('Integrand of f_Z(z)'), xlabel('y'), ylabel('f(y)')