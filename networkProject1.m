close all;
clear;
clc;

% the purpose of this script/project is to simulate a wireless comm setting
% that employes CSMA/CA, and observe throughput and other quantities. 

%simulation parameters:
dataFrameSize = 1500; %bytes
slotDuration = 10e-6; % 10 microsecs
sifsDur = 1;% 1 slot
CW = [8, 16, 32, 64, 128, 256, 512, 1024]; % collision window options
arrivalRate = [100,200,300,400,500,800,1000]; % frames/sec
ACK = 2; % acknowledge time in slots
RTS = 2; CTS = 2; % used for virtual carrier sensing, time in slots
difsDur = 3; % slots
BW = 12e6; % Mbps % bandwidth
maxSimTime = 10; %seconds



% Scenario #1: Single collision domainStations A and B and the access point AP are within
%the same collision domain (any transmission is received by all). Stations A and B generate uplink traffic
%directed to the AP . The traffic pattern at each station follows a Poisson arrival process with an average
%arrival rate of λ frames/sec (more on this in the Appendix).

% first for some variables to keep track of things

nodeA_backoff = 0; % set when a frame is at the top of the buffer and ready to be sent
nodaB_backoff = 0;

% time to transmit should remain constant, as frame size is constant 
% = frame size divided by the bandwidth 
transTime = dataFrameSize*8/BW;
transTimeInSlots = transTime/slotDuration; % same for A and N nodes. 
NAV = transTimeInSlots + sifsDur + ACK; % NAV duraton in slots

% first generate the arrival times for the hosts A and B (using lecture
% video - poisson inter-arrival times, inverse CDF tranfrom method to
% generate random values according to a standard distribution - such as
% poisson
% poisson => f(t) = lambda*exp(-lamda*U)  <----> F(t)  = (-1/lambda)*log(1-U)

%first generate random uniform values from 0 to 1 
%%% FIRST MAKE SURE IT WORKS FOR KNOWN VALUES, then make more complicated
uA = [0.1, 0.15, 0.3]; % still need to determine this length
uB = [0.12, 0.18,0.25]; % Node B needs some randomly generated values as well, but different ones

interArrivalTimes_A = (-1/arrivalRate(1))*log(1-uA);
interArrivalTimes_B = (-1/arrivalRate(1))*log(1-uB);

% divide by slot duration to get arrival time in terms of slots
interArrivalSlots_A = interArrivalTimes_A/slotDuration
interArrivalSlots_B = interArrivalTimes_B/slotDuration

% add next value to previous values to get actually arrival time in slots
arrivalsSlotsA= [];
arrivalsSlotsB = [];
arrivalTimesA = [];
arrivalTimesB = [];
% fill the BUFFER of each station
for i=1:length(interArrivalSlots_A) % number of frames should be same in A and B buffer
    if i ==1
        % first one is special (no previous time)
        arrivalsSlotsA(i) = ceil(interArrivalSlots_A(i));
        arrivalsSlotsB(i) = ceil(interArrivalSlots_B(i));
        % for time
        arrivalTimesA(i) = interArrivalTimes_A(i);
        arrivalTimesB(i) = interArrivalTimes_B(i);

    else
        % add all previous inter arrival slots to the rest
        arrivalsSlotsA(i) = ceil(sum(interArrivalSlots_A(1:i)));
        arrivalsSlotsB(i) = ceil(sum(interArrivalSlots_B(1:i)));
        % for time also
        arrivalTimesA(i) = sum(interArrivalTimes_A(1:i));
        arrivalTimesB(i) = sum(interArrivalTimes_B(1:i));
    end
end


% plot the arrivals in time and slots for sanity check
figure 
scatter(1:length(arrivalsSlotsA), arrivalsSlotsA)
hold on 
scatter(1:length(arrivalsSlotsB), arrivalsSlotsB)
legend('Node A','Node B')
title('Frame Arrival in Slots')
xlabel('Frame arrival #')
ylabel('Arrival Slot')

figure 
scatter(1:length(arrivalTimesA), arrivalTimesA)
hold on 
scatter(1:length(arrivalTimesB), arrivalTimesB)
title('Frame Arrival in Time')
xlabel('Frame arrival #')
ylabel('Arrival time (s)')

% dont forgot to floor all the slot values as they need be integers

% legnth of sim in slots is max value of either arrival slots A or B
maxA = max(arrivalsSlotsA);
maxB = max(arrivalsSlotsB);
if maxA <= maxB
    maxSimSlots = maxB;
else
    maxSimSlots = maxA;
end
disp(['Max Simulation Slots:' num2str(maxSimSlots)])


%%
%%%%%%%%%%%%%%%%%%%%%%%%%    Scenario #1a - CSMA/CA w/ no hidden terminals %%%%%%%%%%%%%
NAV = transTimeInSlots + sifsDur + ACK; % NAV duraton in slots (no RTS/CTS for scenario 1
% strt with lambda = 100 frames / sec
currentSlot = 0;
frameTrackerA = 1;
frameTrackerB = 1;
totalFramesSent_A = 0;
totalFramesSent_B = 0;
currentBackoffA = 6; % change to rand(0, CW-1) once you know other parts are working correclty.
currentBackoffB = 4;
remainingBackoff = 0;
hasRemainingBackoff = 'None'; % other stationg begins to transmit during backoff countdown
transmissionLog = []; % to store [startSlot, endSlot, nodeID] for plotting, use for logging collisions as well
finalTransmission = 'NotYet';
while strcmp(finalTransmission,'Complete') ~=1;
    % main CSMC/CS algorithm here
    % assume transmission cycle has successfully completed t start of simulation
    % 1. compare arrival times (in slots) of two nodes, and start processing them at the lowest number slot of A or B
    % if first arrival slot of A is less than that of B, plan transmit for
    % A
    if hasRemainingBackoff == 'A'
        currentBackoffA = remaining_backoff;
    else
        currentBackoffA = 6; % change to rand(0, CW-1) once you know other parts are working correclty.
    end
   if hasRemainingBackoff == 'B'
        currentBackoffB = remaining_backoff;
    else
        currentBackoffB = 4; % change to rand(0, CW-1) once you know other parts are working correclty.
   end

   % check to see if we jsut need to process remaining frame
   
   %determine the arrival time for current frame at head of buffer
    currentSlotToTransmit_A = arrivalsSlotsA(frameTrackerA);
    currentSlotToTransmit_B = arrivalsSlotsB(frameTrackerB);
    
    % compare arrival times of two stations
    if currentSlotToTransmit_A< currentSlotToTransmit_B          %%%%%%%%%%%_-------------------------------------------> case 1: A is ready to transmit
        % note node A wants to transmit at this point
        currentSlotToTransmit_A = currentSlotToTransmit_A + currentBackoffA + difsDur; % random backoff
        totalFramesSent_A = totalFramesSent_A + 1;

       
        % node A is up
        scheduledNode = 'Node_A';
        transmissionLog = [transmissionLog; currentSlotToTransmit_A, currentSlotToTransmit_A + transTimeInSlots,currentSlotToTransmit_A-currentBackoffA, currentSlotToTransmit_A, 1];
        
        frameTrackerA = frameTrackerA + 1; % process next frame next time around
        if frameTrackerA > length(arrivalTimesA) 
            finalTransmission = 'B'; % A is done transmitting
        end
        % if other station was planning on transmitting before currently
        % transmitting station has recieved ack, defer it untill end of ack and
        % another DIFS has occured
        endOfContentionPeriod = currentSlotToTransmit_A + NAV; 
        if currentSlotToTransmit_B < endOfContentionPeriod

            % defer it to end of ACK and DIFS (begining of another
            % contention period
            %defer transmission of losing station
            shiftB = endOfContentionPeriod - (arrivalsSlotsB(frameTrackerB ));
            arrivalsSlotsB(frameTrackerB) = arrivalsSlotsB(frameTrackerB) + shiftB; % apply shift to losing station
            % hasRemainingBackoff = 'B';

            %also, if it is less than winning stations backoff, 
            

        end

    elseif currentSlotToTransmit_A > currentSlotToTransmit_B      %%%%%%%%%%%_-------------------------------------------> case 2: B is ready to transmit
        currentSlotToTransmit_B = currentSlotToTransmit_B + currentBackoffB + difsDur; % random backoff and DIFSDUR
        totalFramesSent_B = totalFramesSent_B + 1;
 
        % node B is up
        scheduledNode = 'Node_B';
        transmissionLog = [transmissionLog; currentSlotToTransmit_B, currentSlotToTransmit_B + transTimeInSlots, currentSlotToTransmit_B-currentBackoffB, currentSlotToTransmit_B, 2];
        frameTrackerB = frameTrackerB + 1; % process next frame next time around
        if frameTrackerB > length(arrivalTimesB)
            finalTransmission = 'A';
        end


        endOfContentionPeriod = currentSlotToTransmit_B + NAV; 

        if currentSlotToTransmit_A < endOfContentionPeriod
                % defer it to end of ACK and DIFS (begining of another
                % contention period
                %defer transmission of losing station
                shiftA = endOfContentionPeriod - (arrivalsSlotsA(frameTrackerA));
                arrivalsSlotsA(frameTrackerA) = arrivalsSlotsA(frameTrackerA) + shiftA; % apply shift to losing stations current top of buffer
        end
    else
        % collision event will occur when both stations have same arrival
        % of frame, and same backoff time (unlikely but can occur even in
        % single collision domain)
        % handle collision event here or somehow somewhere

        % current frame to process remains the same, do nothing untill
        % begining of next contention window (new random backoff values
        % should be chosen
        
    end
 
    % end contnetion period and keep track of slots processed
    currentSlot = endOfContentionPeriod;

    %%%% --------------------------------------------------------------------------------------------------------------------------------------------Special case handling for final transmission
     % last transmission, no contention
    if finalTransmission == 'A'
        currentSlotToTransmit_A = currentSlotToTransmit_A + currentBackoffA + difsDur; % random backoff
        % is other node still transmitting?
        if currentSlotToTransmit_A < currentSlotToTransmit_B + NAV
            currentSlotToTransmit_A = currentSlotToTransmit_B + NAV + currentBackoffA + difsDur;
        end
        totalFramesSent_A = totalFramesSent_A + 1;
        % node A is up
        scheduledNode = 'Node_A';
        transmissionLog = [transmissionLog; currentSlotToTransmit_A, currentSlotToTransmit_A + transTimeInSlots,currentSlotToTransmit_A-currentBackoffA, currentSlotToTransmit_A, 1];
        finalTransmission = 'Complete';
    end
     if finalTransmission == 'B'
        currentSlotToTransmit_B = currentSlotToTransmit_B + currentBackoffB + difsDur; % random backoff
        if currentSlotToTransmit_B < currentSlotToTransmit_A + NAV
            currentSlotToTransmit_B = currentSlotToTransmit_A + NAV + currentBackoffB + difsDur;
        end
        totalFramesSent_B = totalFramesSent_B + 1;
        % node B is up
        scheduledNode = 'Node_B';
        transmissionLog =  [transmissionLog; currentSlotToTransmit_B, currentSlotToTransmit_B + transTimeInSlots, currentSlotToTransmit_B-currentBackoffB, currentSlotToTransmit_B, 2];
        finalTransmission = 'Complete';
    end

end

%%%%%%%%%%%%%%%%% PLOTTING TRANSMISSION TIMELEINE
figure;
hold on;
for i = 1:size(transmissionLog, 1)



    startSlot = transmissionLog(i, 1);
    endSlot = transmissionLog(i, 2);
    startBackoff = transmissionLog(i, 3);
    endBackoff = transmissionLog(i, 4);
    nodeID = transmissionLog(i, 5);

    startAck = endSlot + sifsDur;
    endAck = startAck + ACK;

    startDIFS = startBackoff-difsDur;
    endDIFS = startDIFS + difsDur;

    startSIFS = endSlot;
    endSIFS = startSIFS + 1;
    % Vertical position for each node
    if nodeID == 1
        y = 0; % Node A
        color = 'b';
    else
        y = 0; % Node B
        color = 'r';
    end
    
    % Plot transmission as a horizontal line
    plot([startSlot, endSlot], [y, y], 'Color', color, 'LineWidth', 4);
    plot([startBackoff, endBackoff], [y,y], 'Color', 'cyan', 'LineWidth', 4)
    plot([startAck, endAck], [y,y], 'Color', 'green', 'LineWidth', 4 )
    plot([startDIFS, endDIFS],[y,y], 'Color','yellow', 'LineWidth',4)
    plot([startSIFS, endSIFS],[y,y], 'Color','k', 'LineWidth',4)


end

% add some more details
hA = plot(NaN, NaN, 'b', 'LineWidth', 4);             % Node A
hB = plot(NaN, NaN, 'r', 'LineWidth', 4);             % Node B
hACK = plot(NaN, NaN, 'g', 'LineWidth', 2);         % ACK
hDIFS = plot(NaN, NaN, 'yellow', 'LineWidth', 4);   %DIFS          
hSIFS = plot(NaN, NaN, 'k', 'LineWidth', 4); %SIFS
hBackOff = plot(NaN, NaN, 'cyan', 'LineWidth', 2);  %BACKOFF
% Add legend entries
legend([hA, hB, hDIFS,  hACK, hSIFS, hBackOff], {'Node A', 'Node B', 'DIFS', 'ACK', 'SIFS', 'BACKOFF'}, ...
       'Location', 'eastoutside', 'Orientation', 'Vertical');
title('CSMC/CA')

%% 
%%%%%%%%%%%%%%%%%%%%%%%%%    Scenario #2a - CSMA/CA/virtualCarrierSensing w/ no hidden terminals (single collision domain) %%%%%%%%%%%%%