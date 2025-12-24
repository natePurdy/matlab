% find the power spectral density of the following autocorrelation functions
syms t f

rx_1 = 1/(1+t^2)

% Compute Fourier transform
X = fourier(rx_1, t, w)

% Simplify (optional)
X_simplified = simplify(X)