%% Jacobson/Karels RTO Convergence
% Count iterations until RTO drops to 4 seconds or lower
clear; clc;

mu = 1;
phi = 4;

RTT_sample = 1; % constant measurement

RTT_estimate = 4;
delta = 0.9; % gain on the delta between estimate and measured

% initial deviation
deviation = 1;
iteration = 0;
timeout = 10000; % arbitrarily larger than our range of interest for the loop
while timeout > 4
    difference = RTT_sample - RTT_estimate; 
    RTT_estimate = RTT_estimate + delta*difference;
    deviation = deviation + delta * (abs(difference) - deviation);
    % timeoutou
    timeout = mu*RTT_estimate + phi*deviation;
    fprintf('Iter %d: timeoutValue=%.3f  RTT_ESTIMATE=%.3f  deviation=%.3f\n', ...
         iteration, timeout, RTT_estimate, deviation);

    iteration = iteration + 1;

end

% fprintf('\nRTO reached 4 seconds after %d iterations.\n', iteration);