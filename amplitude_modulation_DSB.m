%The purpose of this program is to generate a double sideband suppressed
%carrier wave (amplitude modulation) signal and its fourier transform using
%symbolic math (continuous time)

%first the symbolic variables used need to be specified 

syms t w

%now the message signal m(t) = 2*cos(20*pi*t)+sin(4*pi*t)
'The massage signal is:'
m = 2*cos(20*pi*t) + sin(4*pi*t)
%now modulate the carrier signal 
'the DSB/SC modulated signal at carrier frequency 100pi (rad/s) is:'

c = m.*cos(100*pi*t)
%now use the symbolic fourier function to calculate the fourier transform
%of the modulated signal

'The fourier transform of the DSB/SC signal is:'
Cw = fourier(c)

