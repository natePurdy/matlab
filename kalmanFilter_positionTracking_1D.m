% ECE 542 Project Example
clear all
close all
% positional data, X axis ---------------------------------
x = ones(1,50);
for i=1:50
x(i) = 50; % silly function to mock a moving target
end
num_measurements = 100; % keep divisable by 2 that results in integer
meas_uncert = 3;
true_state_value1 = 100;
true_state_value2 = x;
system_state_change = 0.5;
measured_positions = [normrnd(true_state_value1,meas_uncert,[1,num_measurements*system_state_change]) normrnd(true_state_value2,meas_uncert,[1,num_measurements*(1-system_state_change)]) ];
truth_positions = [ones(1,num_measurements*system_state_change).*true_state_value1 ones(1,num_measurements*(1-system_state_change)).*true_state_value2];
% END OF positional data, X axis ---------------------------------
% initialize object position prediction and variance on that prediction
pred_position = 70;
pred_pos_var = 15^2;
resulting_predictions = zeros(1,num_measurements+1);
resulting_variances = zeros(1,num_measurements+1); % +1 due to initial guesses
% now to apply the kalman filtering algorithm
for i=1:num_measurements
if i < 2
% store the data for plotting later
resulting_predictions(i) = pred_position;
resulting_variances(i) = pred_pos_var;
end
% step 1: measure, and the variance on that measurement
tap = measured_positions(i); % place random draw here in the future
% measurment device variance (is modeled as constant here) :
stick_var = meas_uncert^2;
% Step 2: update caluclate the KALMAN GAIN for this iteration
K_gain = pred_pos_var/(pred_pos_var + stick_var)
% now estimate the current state
currentState = pred_position + K_gain*(tap - pred_position);
% update the current variance: (identity matrix - kalman_gain*H_matrix)*previous_variance
current_var = (1-K_gain)*pred_pos_var;
% Step 3: PREDICTION (time update)
% here the predictions are the estimates, if the system is static
pred_position = currentState;
pred_pos_var = current_var;
% store the data for plotting later
resulting_predictions(i+1) = pred_position;
resulting_variances(i+1) = pred_pos_var;
if i > 1
if abs(measured_positions(i) - measured_positions(i-1)) > 10 % filter reset
pred_pos_var = 5^2; % reset
end
end
end
for i=1:num_measurements
iteration_axis(i) = i;
end
figure
plot(resulting_predictions)
hold on
scatter(iteration_axis,measured_positions)
hold on
plot(truth_positions)
title('Kalman Filter Position Estimate Compared to Truth, as a Functon of Measurment Number')
legend('Kalman Filtered Predictions','Actual Measured Values','truth values')
xlabel('Number of Measurements')
ylabel('Distance to Target')
figure
plot(resulting_variances)
title('Variance Collapse')
xlabel('Number of Measurements')
ylabel('Variance')
Part 2
close all
clear all
%% Define the kalman filter to be used (FILTER PARAMETERS
dt = 0.1; % sample rate
u_mat = [1 1]; % some control input matrix u related to acceleration
std_dev_acceleration = 0.3; % standard devaitation of acceleration (2=placeholder)
std_dev_measurement = 2; % standard devaitation of measurement (5=placeholder)
A_mat = [1 dt; 0 1]; % define the A (state) matrix
B_mat = [dt^2/2; dt]; % define the B (input) matrix
H_mat = [1 1]; % define the (state transition) H matrix
Q_mat = [dt^4 dt^3; dt^3 dt^2]*std_dev_acceleration^2; % process noise matrix
R_mat = std_dev_measurement^2; % covariance of the measurment noise matrix
temp_calc = size(A_mat);
unc_mat = eye(temp_calc(1));
pred_mat = [0 ; 0];
% now mock the kalman filter algorithm over time given a fake set of data
time = 0:dt:100;
%fake target truth data (input movement over time here)
truth_data = 0.1*(time.^2-time);
% truth_data =50*sin(time/10);
der_truth = gradient(truth_data)./ gradient(time);
% fake measurements
% measurements = [11.24131123 11.24131123; 50.66527854 50.67427854; -0.05316135 -0.03716135];
% PREALLOCATE I SUPPOSE
pos_predictions = ones(1, length(truth_data));
vel_predictions = ones(1,length(truth_data));
measurements = ones(1, length(truth_data));
kalman_gains_vel = ones(1,length(truth_data));
kalman_gains_pos = ones(1,length(truth_data));
for i=1:length(truth_data)
% mock a measurement
measurement = H_mat*truth_data(i) + normrnd(0,50);
measurements(i) = measurement(1);
%PREDICTION algorithm - return pred_mat
% now lay out the code that would make the prediction
pred_mat = A_mat*pred_mat + B_mat*u_mat; % update the time state
% calculate the covariance of the error P = A*P*A' + Q
unc_mat = A_mat*unc_mat*A_mat.' + Q_mat;
% UPDATE using measurments (return updated params after using meas)
% calculate the kalman gain
K_gain_intermediate_calc = H_mat*unc_mat*H_mat.' + R_mat;
K_gain = (unc_mat*H_mat.')*( inv(K_gain_intermediate_calc));
% store off the gains for plotting
kalman_gains_vel(i) = K_gain(2);
kalman_gains_pos(i) = K_gain(1);
% predictiopn matrix update
pred_mat = round(pred_mat + K_gain*(measurement - H_mat*pred_mat));
pos_predictions(i) = pred_mat(1);
vel_predictions(i) = pred_mat(2); % maybe this is true?
%uncertaintiy matrix update
temp = size(H_mat);
I = eye(temp(2));
unc_mat = (I - (K_gain*H_mat))*unc_mat;
end
figure
plot(pos_predictions)
hold on
scatter( 0:1:length(truth_data)-1, measurements,'y', '.')
legend('Prediction',' Measurements', 'Truth Data')
title("Kalman Filter Applied to Similuated Moving Target - Position Tracking")
ylabel("Position of Target")
xlabel ("Data Sample Taken (Ts = 0.1 second)")
hold on
plot(truth_data)
figure
plot(vel_predictions)
hold on
plot(der_truth)
title("Kalman Filter Applied to Similuated Moving Target - Velocity Tracking")
legend('Prediction','Truth Data')
ylabel("Velocity (m/s)")
xlabel("Data Sample Taken (Ts = 0.1 second)")
figure
plot(kalman_gains_pos)
title('Kalman Gains')
legend('Positional Measurement Gain','Velocity Esitmate Gain')
hold on
plot(kalman_gains_vel)