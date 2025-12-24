% more LTI system
syms x w t

% x_t has autocorrelation 
Rx_t = exp(-t^2/2);
%LTI system response
H_w = exp(-w^2/2); % freuqency

% find Sxy_w
%first need Sx(w)
Sx_w = fourier(Rx_t, t, w)

% in radians
Sxy_w = Sx_w * subs(H_w, w, -w)

% find the cross correlation Rxy(T)
Rxy_t = simplify(ifourier(Sxy_w, w, t))

% find the spectral density of the output
Sy_w = simplify(Sx_w*H_w^2)   % careful here in case absolute value does change function

% now find the autocorrelation of the output
Ry_t = ifourier(Sy_w, w, t)