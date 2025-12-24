% ECE 538 project 2

% This project is about simulating a recieved radar datset of W-Band radar system
% - uses LFM waveform with STRETCH PROCESSING
% 
% Center frequency: 77GHz
% Sweep frequency: 76.8GHz-77.2GHz
% Pulse width: 20𝜇𝑠
% PRI: 30𝜇𝑠
% Fast time sample/chirp: 400
% Number of chirps: 500
% Fast time sampling frequency: 20MHz

%% ~~~~~~~~~~~~~~~~~~ GIVEN CODE FOR DATA GENERATION
clear;
close all;
apply_window_fast = 1; %use to turn on/off window function
apply_window_slow = 1;
f_c=77e9; % center frequency
f_start=76.8e9;% chirp starting frequency
f_stop=77.2e9;% chirp end frequency
PRI=30e-6;%Pulse Repetition Interval
P_T=20e-6; %chirp pulse width
M=400; % fast time samples
K=500; % number of chirps
f_s=20e6; % ADC sample frequency
c=3e8; % light speed
dt=1/f_s;
thermal_noise_power=0; % thermal noise power

R_ua = c*f_s*P_T/(2*(f_stop-f_start));


R=[10,20]';
v=[14,30]';
RCS=[100,100]';
% generate noise for data cube
thermal_noise=normrnd(0,1,M,K)+1i.*normrnd(0,1,M,K);
thermal_noise=thermal_noise*sqrt(thermal_noise_power);

% compute range frequency of each target return
f_r=2*R/c*(f_start-f_stop)/P_T;
figure
scatter(1:1:length(R),f_r)
legend('targets')
title('range freq of target return')

% compute doppler frequency of each target return
f_d=2*v*f_c/c;
figure
scatter(1:1:length(R),f_d)
legend('targets')
title('doppler freq of target returns')
% PRI length in samples
pri_len = round(PRI*f_s);

% compute amplitude of target return
%Pr = (Pt*G^2*lambda^2*RCS)/((4*pi)^3*R^4);
%
% equation assumes:
%   (Pt*G^2*lambda^2)/((4*pi)^3) = 1
%
RCS=sqrt(RCS);
amp=((RCS)./R.^2);

% time axis for a pulse (s)
t_pulse=dt*(0:(pri_len-1));

% time axis for a cpi (s)
t_cpi=dt*(0:(pri_len*K-1));

% compute return of target due to range effects only
% repeats each pulse due to indentical transmit signal
rec1 = repmat(exp(1i*2*pi*f_r.*t_pulse),1,K);

% ???????
if apply_window_fast>0
    % introduce window function here?
    hamm_length = [0:P_T/pri_len:P_T];
    hamm_window = normpdf(hamm_length,0,0.00005);
    figure
    plot(hamm_window)
    title("Window function")
    rec1 = repmat(exp(1i*2*pi*f_r.*t_pulse).*hamm_window(1:end-1),1,K);
end


% figure
scatter(1:1:pri_len*1000/2,rec1(1,:),'.')
hold on 
scatter(1:1:pri_len*1000/2,rec1(2,:),'.')
legend('tgt1', 'tgt2')
title('return of targets for range')



% compute doppler shift of each target return
% complex exponential operates over full CPI
% produce doppler shift and range-doppler coupling
rec2 = exp(1i*2*pi*f_d.*t_cpi);


figure
scatter(1:1:PRI*10e9,rec2, '.')
legend('tgt1', 'tgt2')
title('doppler shift of target returns')
% compute overall return using superposition of each target return
rec3 = sum(amp.*rec1.*rec2,1);

% compute data cube due to signal returns only
received = reshape(rec3,pri_len,K);
received = received(1:M,:);

% compute total received data cube (signal + noise)
data_cube=received+thermal_noise;
%%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ (40 points) Question #1:
% In the simulation, set the thermal noise power to 0, and set two targets as below:
% R=[10,100]';
% v=[15,10]';
% RCS=[1,10000]';
% Do range compression ⇒ doppler compression. Show the range-doppler figure you generated.
% Compare the amplitude between two targets in the range-doppler domain.


% see what the data cube looks like
figure
mesh(real(data_cube))
title("Data Dube Raw")
xlabel("slow Time data")
ylabel("fast Time data")
zlabel("Amplitude of Real Part")

% apply fft to get the range frequencyies
%grab the fast time data (400 points) for each pulse
% 
L_fast = 400;
T = PRI;
Fs_fast = 20e6;
chirp_B = f_stop-f_start;

% try out a single fast time data pulse set
% MATLAB fft 
Y = fft(data_cube(:,1));
figure
% try converting freq axis to time then range ultimately (CRP - "delta ranges")
scatter(R_ua-Fs_fast/L_fast*(0:L_fast-1)*P_T/chirp_B*c/2,abs(Y),'.',"LineWidth",3)
title("Complex Magnitude of fft Spectrum")
xlabel("Range m")
ylabel("|fft(X)|")
% [frq, amp, phase] = simpleFFT( data_cube(:,1), Fs_fast);
% figure 
% scatter(frq,amp, '.')
% title(['Simple fft of one column (fast time) of data cube'])
%try doing the fast time processing for whole datacube
res = cell(size(data_cube));
for i=1:500
    temp = fft(data_cube(:,i));
    for k=1:400
        res{k,i} = temp(k);
    end

end
res = cell2mat(res);
figure
mesh(abs(res))
title("fft of range data only")
xlabel("slow time samples")
ylabel("Range")
zlabel("Amplitude")


res2 = cell(size(data_cube));

% Slow time data needs different parameters for FFT
L_slow = 500;
T = PRI;
Fs_slow = 1/PRI;

% ----------------------------------- try out a single slow time data pulse set
% MATLAB fft 
Y = fft(data_cube(1,:));
figure
scatter(Fs_slow/L_slow*(0:L_slow-1)*c/(2*f_c),abs(Y),'.',"LineWidth",3)
title("Complex Magnitude of fft Spectrum 2")
xlabel("freq")
ylabel("|fft(X)|")
figure
plot(1:1:500,data_cube(1,:))
title("Slice of slow time data")
xlabel("data point")
ylabel("amplitude")
% now try to do the slow time processing for the data cube

for i=1:400
    % this is probably where we would want to apply the dinwo function for
    % the doppler data,s ince we are already accessing it here.
    % what window to use?
    temp = fft(res(i,:));
    for k=1:500
        res2{i,k} = temp(k);
    end

end
if apply_window_slow>0
    % introduce window function here?
    hamm_length = [0:1:L_slow];
    hamm_window = 100*normpdf(hamm_length,0,L_slow/2);
    figure
    plot(hamm_window)
    title("Window function for doppler")   
    for i=1:400
        % this is probably where we would want to apply the dinwo function for
        % the doppler data,s ince we are already accessing it here.
        % what window to use?
        temp = fft(hamm_window(1:end-1).*res(i,:));
        for k=1:500
            res2{i,k} = temp(k);
        end
    end

end

res2 = cell2mat(res2);
figure
mesh(abs(res2))
title("Complex Magnitude of fft Spectrum 3")
xlabel("slow time data")
ylabel("fast time data")
zlabel("Amplitude")


% need to make it so the plot shows two spikes, as one target should have a
% single freq while another target has a differetn frequency, and each
% differing ranges as well

res3 = res2;
figure
mesh(Fs_slow/L_slow*(0:L_slow-1)*c/(2*f_c)/30,R_ua-(Fs_fast/L_fast*(0:L_fast-1)*P_T/chirp_B)*c/2,abs(res3))
title("Compressed in Fast and Slow Time")
xlabel("Velocity (m/s)")
ylabel("Range (m)")
zlabel("Amplitude")


% ------------------- NEXT QUESTION -----------------------
% In the simulation, set the thermal noise power to .0001, and set two targets as below:
% R=[10,10]'; % target range
% v=[15,14]'; % target velocity
% RCS=[100,1]'; % target RCS


% a) Do range compression ⇒ magnitude compensation ⇒ doppler compression. Show the range-
% doppler figure you generated. Compare the amplitude between the two targets in the range-
% doppler domain.

%try doing the fast time processing for whole datacube
res = cell(size(data_cube));
for i=1:500
    temp = fft(data_cube(:,i));
    for k=1:400
        res{k,i} = 10^2*temp(k);
    end

end
res = cell2mat(res);

res2 = cell(size(data_cube));
% Perform range compensattion


% Slow time data needs different parameters for FFT
L_slow = 500;
T = PRI;
Fs_slow = 1/PRI;

% ----------------------------------- try out a single slow time data pulse set

% now try to do the slow time processing for the data cube
for i=1:400
    temp = fft(res(i,:));
    for k=1:500
        % do magnitude compensation (10 meters range)
        res2{i,k} = temp(k);
    end

end
res2 = cell2mat(res2);
figure
mesh(abs(res2))
title("Complex Magnitude of fft Spectrum 3")
xlabel("slow time data")
ylabel("fast time data")
zlabel("Amplitude")


% need to make it so the plot shows two spikes, as one target should have a
% single freq while another target has a differetn frequency, and each
% differing ranges as well

res3 = res2;
figure
mesh(Fs_slow/L_slow*(0:L_slow-1)*c/(2*f_c),R_ua-(Fs_fast/L_fast*(0:L_fast-1)*P_T/chirp_B)*c/2,abs(res3))
title("Compressed in Fast and Slow Time, Magnitude Compensated")
xlabel("Velocity (m/s)")
ylabel("Range (m)")
zlabel("Amplitude")

if apply_window_fast>0
    res3 = res2;
    figure
    mesh(Fs_slow/L_slow*(0:L_slow-1)*c/(2*f_c),R_ua-(Fs_fast/L_fast*(0:L_fast-1)*P_T/chirp_B)*c/2,abs(res3))
    title("Result Using Range Window and Doppler Window")
    xlabel("Velocity (m/s)")
    ylabel("Range (m)")
    zlabel("Amplitude")
end



% b) Do range windowing ⇒ range compression ⇒ magnitude adjustment ⇒ doppler windowing
% ⇒doppler compression. Show the range-doppler figure you generated. (You may try hamming
% window or any other window) Compare the amplitude between the two targets in the range-
% doppler domain.


% for range windowing, not sure what to do...
% do we apply it to the function before the data cube is generated, or
% after the data cube is generated??


% ---> probably before
% but what about doppler windowing?

% maybe we can ignore it for now

% (30 points) Question #3:
% a) What is the range resolution, velocity resolution, range ambiguity, doppler ambiguity of the
% system.
% b) Select appropriate thermal noise, and show what will happen if one target’s range is 200m,
% and velocity 80m/s. Generate range-doppler figure to support your idea.
% c) Any idea on how to overcome the problem shown in b)?


% range resolultion due to sampling rate
range_resolution_nominal = c/(2*(f_stop-f_start))
range_resolution_f_s = c/(2*f_s)

% doppler swath length due to PRI
doppler_swath_upper = (c/f_c)/(2*PRI)
doppler_swath_lower = 0;

% doppler resolution
doppler_res = doppler_swath_upper / 500


