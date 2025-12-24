%this program is meant to help understand the DSB/SC AM method numerically
%and graph the results of the frequency spectrum

%first we need to generate the psuedo storage of 8 bits for generating the
%time vector (independent variable) in 0.1s increments

t = 0.01*(1:256);

%now we need to generate the message signal to be carried
m = 2*cos(20*pi*t) + 4*sin(4*pi*t);
%display the message signal for visual verification
subplot(3,1,1), plot(t,m), title('The message signal m(t)'),grid
%now we need to modulate the message signal with the carrier signal
candm = m.*cos(100*pi*t);
%now display the message signal being carrioed
subplot(3,1,2), plot(t,candm), title('DSB/SC-AM Signal'),grid
%use the fast fourier transform (fft) to approximate the fourier transform
%of the modulated signal
candmF = fft(candm,256);
%now generate the frequency vector of 256 elements
f = 2*pi*(1:256)/(256*0.01);
%now plot the manitude spectrum of the modulated signal and display the
%massage signal
subplot(3,1,3), plot(f,abs(candmF)), title('DSB/SC-AM Frequency Spectrum'), grid,grid
