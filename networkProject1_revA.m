close all;
clear;
clc;

% the purpose of this script/project is to simulate a wireless comm setting
% that employes CSMA/CA, and observe throughput and other quantities. 

%simulation parameters:
dataFrameSize = 1500; %bytes
dataFrameBits = 1500*8;
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

% first generate the arrival times for the hosts A and B (using lecture
% video - poisson inter-arrival times, inverse CDF tranfrom method to
% generate random values according to a standard distribution - such as
% poisson
% poisson => f(t) = lambda*exp(-lamda*U)  <----> F(t)  = (-1/lambda)*log(1-U)

%first generate random uniform values from 0 to 1 
%%% FIRST MAKE SURE IT WORKS FOR KNOWN VALUES, then make more complicated
% uA = [0.1, 0.15, 0.3, 0.4, 0.1, 0.2]; % still need to determine this length
% uB = [0.1, 0.18,0.25, 0.3, 0.11, 0.12]; % Node B needs some randomly generated values as well, but different ones
for i=1:length(arrivalRate)
    lambdaChosen = arrivalRate(i);                                                                                                              %%%%%%%%% control arrival rate here!
    numVals = 10*lambdaChosen; % ~10*lambda (actually just cap it in the main loop using elapsed time, 
    %choose whether or not to run with VCS
    vcsFlag = 0; % --------------------------------------------------- USE Virtual carrier sensing
    a = 0;
    b = 1;
    rng(10); % Set the seed to 0 (change when not testing)
    uA = (b - a) * rand(numVals, 1) + a;
    uB = (b - a) * rand(numVals, 1) + a;
    % choice of arrival rate (lambda):
    interArrivalTimes_A = (-1/lambdaChosen)*log(1- uA);
    interArrivalTimes_B = (-1/lambdaChosen)*log(1- uB);
    
    % divide by slot duration to get arrival time in terms of slots
    interArrivalSlots_A = interArrivalTimes_A/slotDuration;
    interArrivalSlots_B = interArrivalTimes_B/slotDuration;
    
    % add next value to previous values to get actually arrival time in slots
    arrivalsSlottedA= [];
    arrivalsSlottedB = [];
    arrivalTimesA = [];
    arrivalTimesB = [];
    % fill the BUFFER of each station
    for i=1:length(interArrivalSlots_A) % number of frames should be same in A and B buffer
        if i ==1
            % first one is special (no previous time)
            arrivalsSlottedA(i) = ceil(interArrivalSlots_A(i));
            arrivalsSlottedB(i) = ceil(interArrivalSlots_B(i));
            % for time
            arrivalTimesA(i) = interArrivalTimes_A(i);
            arrivalTimesB(i) = interArrivalTimes_B(i);
    
        else
            % add all previous inter arrival slots to the rest
            arrivalsSlottedA(i) = ceil(sum(interArrivalSlots_A(1:i)));
            arrivalsSlottedB(i) = ceil(sum(interArrivalSlots_B(1:i)));
            % for time also
            arrivalTimesA(i) = sum(interArrivalTimes_A(1:i));
            arrivalTimesB(i) = sum(interArrivalTimes_B(1:i));
        end
    end
    
    
    % plot the arrivals in time and slots for sanity check
    figure 
    scatter(1:length(arrivalsSlottedA), arrivalsSlottedA)
    hold on 
    scatter(1:length(arrivalsSlottedB), arrivalsSlottedB)
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
    
    
    
    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%    Scenario #1a - CSMA/CA single domain %%%%%%%%%%%%%
    if vcsFlag ==1 % scenario 2a: CSMA/CA single domain with VCS (similar but w/ RTS and CTS before transmission
        NAV = sifsDur*2+ CTS + transTimeInSlots + sifsDur + ACK; % w/VCS
    else
        NAV = transTimeInSlots + sifsDur + ACK; % NAV duraton in slots (no RTS/CTS for scenario 1 - )
    end
    % strt with lambda = 100 frames / sec
    currentSlot = 0;
    numCollisions = 0;
    frameTrackerA = 1;
    frameTrackerB = 1;
    remainingBackoff = 0;
    hasRemainingBackoff = 'None'; % other station begins to transmit during backoff countdown
    transmissionLog = {'Transmit_Begin', 'Transmit_End', 'Backoff_Begins', 'EndOfContentionPeriod', 'Node_Transmitting',...
        'Arrival_Slot', 'ContentionPeriod_EndTime', 'CW_size', 'frameTrackerA', 'frameTrackerB', 'countDownWinnerA', 'countDownWinnerB' }; % to store [[ transmits here, transmit ends here, countdown of backoff begins here, node ]] for plotting, use for logging collisions as well
    lonelyStation = 'NotYet'; % dont judge
    countDownWinnerA = 0; % if there is a race condition with the backoff timers, 
    countDownWinnerB = 0; % who is the winner? keep track for fairness
    cw = 1; %initial choice of contantion window
    % figure;
    % hold on;
    % use some keyword and condition to trigger end of simulation
    
    while strcmp(lonelyStation,'Complete') ~=1 
         %%%%% CURRENT CONTENTION PERIOD DATA BEGIN
        % main CSMC/CS algorithm here
        % assume transmission cycle has successfully completed t start of simulation
        % 1. compare arrival times (in slots) of two nodes, and start processing them at the lowest number slot of A or B
        % if first arrival slot of A is less than that of B, plan transmit for
        % A
        % set the window to use during contingency for backoff values
        winner = 'none';
        CW_current = CW(cw);
        currentBackoffA = randi([0 CW_current-1]); % change to rand(0, CW-1) once you know other parts are working correclty.
        currentBackoffB = randi([0 CW_current-1]); % change to rand(0, CW-1) once you know other parts are working correclty.
        if hasRemainingBackoff == 'A'
            currentBackoffA = remaining_backoff;
        end
       if hasRemainingBackoff == 'B'
            currentBackoffB = remaining_backoff;
       end
        remainingBackoff = 0; % reset contention variables that may change per round
        hasRemainingBackoff = 'none';
    
       % check to see if we jsut need to process remaining frame
    
       %%%% for each contention , determine characteristics about the planned
       %%%% node transmission to determine what condition the arrivals fall
       %%%% into ( there are a few, depending on the relative arrival time of
       %%%% A and B traffic)
       if length(arrivalsSlottedA) < frameTrackerA && length(arrivalsSlottedB) < frameTrackerB
            lonelyStation = 'Complete'; % end the run if everyone is done with arrivals
       end
      
       % case 0.1: most frequest case: both stations A and B still have at
       % least one frame to transmit, see whats up with the arrivals
       if length(arrivalsSlottedA) >= frameTrackerA && length(arrivalsSlottedB) >= frameTrackerB
            % aquire station data
            [currentArrival_A, currentArrival_B,endOfBackoff_A, endOfBackoff_B, endNav_A, endNav_B]...
                = probeBufferTops(arrivalsSlottedA, arrivalsSlottedB,frameTrackerA, frameTrackerB, currentBackoffA, currentBackoffB, difsDur, NAV, vcsFlag, RTS);
       end
    
       % first check to see if one of the stations is done stransmitting
       if frameTrackerA > length(arrivalsSlottedA) % stations A is done
           [lonelyStation, transmissionLog] = ...
               stationA_IsDone(arrivalsSlottedB, frameTrackerB, currentBackoffB, transmissionLog, difsDur, endOfBackoff_A, NAV,transTimeInSlots, slotDuration, CW_current, frameTrackerA, countDownWinnerA, countDownWinnerB, vcsFlag, RTS);
       elseif frameTrackerB > length(arrivalsSlottedB) % stations B is done
           [lonelyStation,transmissionLog] = ...
               stationB_IsDone(arrivalsSlottedA, frameTrackerA, currentBackoffA, transmissionLog, difsDur,endOfBackoff_B, NAV,transTimeInSlots, slotDuration, CW_current, frameTrackerB, countDownWinnerA, countDownWinnerB, vcsFlag, RTS);
    
    
        % case 1: node B has an arrival during node A's transmission --> node B
        % is defferred USING NAV
        elseif  currentArrival_B > endOfBackoff_A && currentArrival_B < endNav_A % case: A is first, B arrival during A's transmission, defer B to end of NAV
           % node A is up
            winner = 'Node_A';
            % log events [ transmits here, transmit ends here, countdown of backoff begins here, node ]
            endOfContentionPeriod = endNav_A;
            frameTrackerA = frameTrackerA + 1; % process next frame next time around        
            transmissionLog = [transmissionLog; {endOfBackoff_A, endOfBackoff_A + transTimeInSlots,endOfBackoff_A-currentBackoffA,endOfContentionPeriod 'Node_A', currentArrival_A,  endOfContentionPeriod*slotDuration, CW_current, frameTrackerA, frameTrackerB, countDownWinnerA, countDownWinnerB}];
    
            % now handle B
            % defer it to end of A's trans
            shiftB = endNav_A - currentArrival_B;
            arrivalsSlottedB(frameTrackerB) = arrivalsSlottedB(frameTrackerB) + shiftB; % apply shift to losing stationarrivalsSlottedB(frameTrackerB:end) = arrivalsSlottedB(frameTrackerB:end) + shiftB; % apply shift to losing station
            
        % case 2: Node A has arrival during node B's transmission
       elseif currentArrival_A > endOfBackoff_B && currentArrival_A < endNav_B
            % node B is up
            winner = 'Node_B';  
            endOfContentionPeriod = endNav_B;
            frameTrackerB = frameTrackerB + 1; % process next frame next time arounD        
            transmissionLog = [transmissionLog; {endOfBackoff_B, endOfBackoff_B + transTimeInSlots, endOfBackoff_B-currentBackoffB,endOfContentionPeriod, 'Node_B',currentArrival_B,endOfContentionPeriod*slotDuration, CW_current, frameTrackerA, frameTrackerB, countDownWinnerA, countDownWinnerB}];
    
    
            % now handle A
            % defer it to end of B's trans
            shiftA = endNav_B - currentArrival_A;
            arrivalsSlottedA(frameTrackerA) = arrivalsSlottedA(frameTrackerA) + shiftA; % apply shift to losing station (ell elements since sequenctial
        
         % case 3: Simple case: No contention necassary since no overlap
         % simply process the sooner one and advance to next round. 
        elseif currentArrival_B >= endNav_A 
            % node A is up
            winner = 'Node_A';
            % log events
            endOfContentionPeriod = endNav_A;
            transmissionLog = [transmissionLog; {endOfBackoff_A, endOfBackoff_A + transTimeInSlots,endOfBackoff_A-currentBackoffA, endOfContentionPeriod, 'Node_A',currentArrival_A, endOfContentionPeriod*slotDuration, CW_current, frameTrackerA, frameTrackerB, countDownWinnerA, countDownWinnerB}];
            frameTrackerA = frameTrackerA + 1; % process next frame next time around
    
    
        % second part of case 3 - no contention round
       elseif currentArrival_A >= endNav_B
            % node B is up
            winner = 'Node_B';
            endOfContentionPeriod = endNav_B;
            frameTrackerB = frameTrackerB + 1; % process next frame next time arounD        
            transmissionLog = [transmissionLog; {endOfBackoff_B, endOfBackoff_B + transTimeInSlots, endOfBackoff_B-currentBackoffB, endOfContentionPeriod, 'Node_B', currentArrival_B, endOfContentionPeriod*slotDuration, CW_current, frameTrackerA, frameTrackerB, countDownWinnerA, countDownWinnerB}];
        
       % case 4: both A and B sensed line idle and plan to --- RACE CONDITION
       % transmit, and begin countdown to backoff -- % A does not sense line is
       % busy, B is in countdown already, or vise versa --> figure out who wins
       % the contention
        elseif currentArrival_B >= currentArrival_A && currentArrival_B <= endOfBackoff_A || currentArrival_A >= currentArrival_B && currentArrival_A <= endOfBackoff_B   
            if endOfBackoff_A < endOfBackoff_B  % A wins the backoff timer
               % node A is up
               winner = 'Node_A';
                % log events for the winning node
                endOfContentionPeriod = endNav_A;
                frameTrackerA = frameTrackerA + 1; % process next frame next time around
                transmissionLog = [transmissionLog; {endOfBackoff_A, endOfBackoff_A + transTimeInSlots,endOfBackoff_A-currentBackoffA, endOfContentionPeriod,'Node_A', currentArrival_A,endOfContentionPeriod*slotDuration, CW_current, frameTrackerA, frameTrackerB, countDownWinnerA, countDownWinnerB}];
    
                % now handle B, considering it was in countdown but then deferred
                % once A began transmission
                % defer it to end of A's trans
                shiftB = endNav_A - currentArrival_B;
                arrivalsSlottedB(frameTrackerB) = arrivalsSlottedB(frameTrackerB) + shiftB; % apply shift to losing stations arrival slot
                hasRemainingBackoff = 'B';
                % how do we know how much backoff is left?
                remaining_backoff = endOfBackoff_B - endOfBackoff_A; 
                % unless the backoff never was started in the first
                % place...then:
                if (remaining_backoff > currentBackoffB)
                    remaining_backoff = currentBackoffB;
                end
                countDownWinnerA = countDownWinnerA + 1;
            end
            if endOfBackoff_B < endOfBackoff_A    % B wins the backoff counter
                % node B is up
                winner = 'Node_B';
                endOfContentionPeriod = endNav_B;
                frameTrackerB = frameTrackerB + 1; % process next frame next time arounD
                transmissionLog = [transmissionLog; {endOfBackoff_B, endOfBackoff_B + transTimeInSlots, endOfBackoff_B-currentBackoffB, endOfContentionPeriod, 'Node_B',currentArrival_B,endOfContentionPeriod*slotDuration, CW_current, frameTrackerA, frameTrackerB, countDownWinnerA, countDownWinnerB}];
        
                % now handle A, was in countdown, now deferred
                % defer it to end of B's trans
                shiftA = endNav_B - currentArrival_A;
                arrivalsSlottedA(frameTrackerA) = arrivalsSlottedA(frameTrackerA) + shiftA; % apply shift to losing station
                hasRemainingBackoff = 'A';
                remaining_backoff = endOfBackoff_A - endOfBackoff_B; % use the remaining backoff next contention round
                % unless the backoff never was started in the first place...
                if (remaining_backoff > currentBackoffA)
                    remaining_backoff = currentBackoffA;
                end
                countDownWinnerB = countDownWinnerB + 1;
    
            end
                % collision has single possible possible event, should be caught
            % here..
            if endOfBackoff_A == endOfBackoff_B 
                numCollisions = numCollisions + 1;
                % double the contention window
                if CW_current < 1024
                    cw = cw + 1;
                else
                    cw = 8; % hold at max if = 1024
                end
                if vcsFlag ==1 % with vcs, collision is realized when no CTS recieved by sender
                    endOfContentionPeriod = endOfBackoff_A + RTS + CTS + sifsDur*2; % both have same backoff end point at this point
                else
                    endOfContentionPeriod = endOfBackoff_A + NAV;
                end
                transmissionLog = [transmissionLog; {0, 0, 0, endOfContentionPeriod, 'COLLISION', endOfBackoff_A, endOfContentionPeriod*slotDuration,CW_current, frameTrackerA, frameTrackerB, countDownWinnerA, countDownWinnerB}];
                % advance both of the arrivals to the end of the contention
                % period (CTS + RTS + attermptedTransmissionPoint for VCS, NAV + attermptedTransmissionPoint for no VCS)
                arrivalsSlottedA(frameTrackerA) = endOfContentionPeriod;
                arrivalsSlottedB(frameTrackerB) = endOfContentionPeriod;
            end
    
       end 
    
        % hack on to align queue of frames in buffer if next one shows up
        % during current ones transmission
        if frameTrackerB <= length(arrivalsSlottedB) 
           if arrivalsSlottedB(frameTrackerB) < endNav_B && strcmp(winner,'Node_B') 
                % winning stations next arrival needs to also be delayed if
                % planned arrival before own NAV complete...
                arrivalsSlottedB(frameTrackerB) = endNav_B;
           end
        end
        if frameTrackerA <= length(arrivalsSlottedA) 
            if arrivalsSlottedA(frameTrackerA) < endNav_A && strcmp(winner, 'Node_A') 
                % winning stations next arrival needs to also be delayed if
                % planned arrival before own NAV complete...
                arrivalsSlottedA(frameTrackerA) = endNav_A;
            end
        end
    
        % reset the backoff counter if a transmission is successful
        if ~ strcmp(winner, 'none')
            cw = 1;
        end
    
        
    end

    % % PLOT SIM RESULT TIMELINE (MESSY BUT USEFUL)
    % for i=2:length(transmissionLog(:,1))
    %     plotContentionPeriod(i, sifsDur, ACK, difsDur, transmissionLog)
    % end
    
    
    %% WRITE DATA TO TEXT FILE
    writeDataToFile(lambdaChosen, transmissionLog,dataFrameBits, numCollisions, vcsFlag, frameTrackerA, frameTrackerB)
end
%% 
%%%%%%%%%%%%%%%%%%%%%%%%%    Scenario #2a - CSMA/CA/virtualCarrierSensing w/ no hidden terminals (single collision domain) %%%%%%%%%%%%%


function plotContentionPeriod(k, sifsDur, ACK, difsDur, transmissionLog)
    beginTransmitSlot = transmissionLog{k, 1};
    endTransmitSlot = transmissionLog{k, 2};
    startBackoff = transmissionLog{k, 3};
    endContention = transmissionLog{k, 4};
    nodeID = transmissionLog{k, 5};

    % force feed in the acks, difs, and sifs as i didnt track them during
    % sim (hopefully it lines up...)
    startAck = endTransmitSlot + sifsDur;
    endAck = startAck + ACK;

    startDIFS = startBackoff-difsDur;
    endDIFS = startDIFS + difsDur;

    backoffPeriod = startBackoff - beginTransmitSlot;

    startSIFS = endTransmitSlot;
    endSIFS = startSIFS + 1;

    % Vertical position for each node
    if strcmp(nodeID, 'Node_A')
        y = 0.01; % Node A
        color = 'b';
    else
        y = 0.01; % Node B
        color = 'r';
    end



    % Plot transmission as a horizontal line
    if  (strcmp(transmissionLog{k, 5}, 'COLLISION'))
        line([transmissionLog{k, 4} transmissionLog{k, 4}], [0.01, 0.011 ]); % note collision
    else
        plot([beginTransmitSlot, endTransmitSlot], [y, y], 'Color', color, 'LineWidth', 2,'LineStyle','-');
        plot([ startBackoff, beginTransmitSlot], [y,y], 'Color', 'cyan', 'LineWidth', 4)
        plot([startAck, endAck], [y,y], 'Color', 'green', 'LineWidth', 4 )
        plot([startDIFS, endDIFS],[y,y], 'Color','yellow', 'LineWidth',4)
        plot([startSIFS, endSIFS],[y,y], 'Color','k', 'LineWidth',4)
        ylim([0.009,0.0105])

    if k == length(transmissionLog(:,1))% note the different colors
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
        title('CSMC/CA - n Arrivals/second')
    end
    end

end

function [lonelyStation, transmissionLog] = stationA_IsDone...
    (arrivalsSlottedB, frameTrackerB, currentBackoffB, transmissionLog, difsDur, endOfBackoff_A, NAV, transTimeInSlots, slotDuration, CW_current, frameTrackerA, countDownWinnerA, countDownWinnerB, vcsFlag, RTS)

        for i=0:length(arrivalsSlottedB) - frameTrackerB
            % only process B until its done
            currentArrival_B = arrivalsSlottedB(frameTrackerB);
            endOfBackoff_B = currentArrival_B + currentBackoffB + difsDur; % random backoff and DIFSDUR
            if vcsFlag ==1
                endNav_B = endOfBackoff_B + NAV + RTS; % account for extra RTS     
            else
                endNav_B = endOfBackoff_B + NAV;
            end
            % node B is up
            if i ==0 % other node has just finished transmitting
                if endOfBackoff_B < endOfBackoff_A + NAV
                    endOfBackoff_B = endOfBackoff_A + NAV + currentBackoffB;
                end
                % node B is up
                endOfContentionPeriod = endOfBackoff_B + NAV;
                transmissionLog =  [transmissionLog; {endOfBackoff_B, endOfBackoff_B + transTimeInSlots, endOfBackoff_B-currentBackoffB, endOfContentionPeriod, 'Node_B', currentArrival_B,endOfContentionPeriod*slotDuration, CW_current, frameTrackerA, frameTrackerB, countDownWinnerA, countDownWinnerB} ];
            else
            
            endOfContentionPeriod = endNav_B;
            transmissionLog = [transmissionLog; {endOfBackoff_B, endOfBackoff_B + transTimeInSlots, endOfBackoff_B-currentBackoffB, endOfContentionPeriod, 'Node_B',currentArrival_B,endOfContentionPeriod*slotDuration, CW_current, frameTrackerA, frameTrackerB, countDownWinnerA, countDownWinnerB}];
            end
            frameTrackerB = frameTrackerB + 1; % process next frame next time arounD
            % dont forget to shift the next frame if it was going to arrive
            % during its own stations transmission
             if frameTrackerB <= length(arrivalsSlottedB)
                if arrivalsSlottedB(frameTrackerB) < endOfContentionPeriod
                    arrivalsSlottedB(frameTrackerB) = endOfContentionPeriod; 
                end
             end

            if ((transmissionLog{end,7} >= 9.999))
                break;
            end
        end

        lonelyStation = 'Complete';

end

function [lonelyStation, transmissionLog] = stationB_IsDone...
    (arrivalsSlottedA, frameTrackerA, currentBackoffA, transmissionLog, difsDur, endOfBackoff_B,NAV, transTimeInSlots, slotDuration, CW_current, frameTrackerB, countDownWinnerA, countDownWinnerB, vcsFlag, RTS)
  
        for i=0:length(arrivalsSlottedA) - frameTrackerA %stupid matlab
            % node A is up against itself
            % only process A until its done
            currentArrival_A = arrivalsSlottedA(frameTrackerA);
            endOfBackoff_A = currentArrival_A + currentBackoffA + difsDur; % random backoff and DIFSDUR
            if vcsFlag ==1
                endNav_A = endOfBackoff_A + NAV + RTS; % account for extra RTS     
            else
                endNav_A = endOfBackoff_A + NAV;
            end
            if i ==0 % other node has just finished transmitting
                if endOfBackoff_A < endOfBackoff_B + NAV
                    endOfBackoff_A = endOfBackoff_B + NAV + currentBackoffA;
                end
                % node B is up
                
                endOfContentionPeriod = endOfBackoff_A + NAV;
                transmissionLog =  [transmissionLog; {endOfBackoff_A, endOfBackoff_A + transTimeInSlots, endOfBackoff_A-currentBackoffA, endOfContentionPeriod, 'Node_A', currentArrival_A,endOfContentionPeriod*slotDuration, CW_current, frameTrackerA, frameTrackerB, countDownWinnerA, countDownWinnerB} ];          
            else
           
            endOfContentionPeriod = endNav_A;
            
            transmissionLog = [transmissionLog; {endOfBackoff_A, endOfBackoff_A + transTimeInSlots, endOfBackoff_A-currentBackoffA, endOfContentionPeriod, 'Node_A',currentArrival_A,endOfContentionPeriod*slotDuration, CW_current, frameTrackerA, frameTrackerB, countDownWinnerA, countDownWinnerB}];
            end
            
            frameTrackerA = frameTrackerA + 1; % process next frame next time arounD
            % dont forget to shift the next frame if it was going to arrive
            % during its own stations transmission
            if frameTrackerA <= length(arrivalsSlottedA)
                if arrivalsSlottedA(frameTrackerA) < endOfContentionPeriod
                    arrivalsSlottedA(frameTrackerA) = endOfContentionPeriod; 
                end
            end
            if ((transmissionLog{end,7} >= 9.999))
                break;
            end
        end
        lonelyStation = 'Complete';
 
       
end


function [currentArrival_A, currentArrival_B,endOfBackoff_A, endOfBackoff_B, endNav_A, endNav_B] ...
    = probeBufferTops(arrivalsSlottedA, arrivalsSlottedB, frameTrackerA, frameTrackerB, currentBackoffA, currentBackoffB, difsDur, NAV, vcsFlag, RTS)
    %determine the arrival time for current frame at head of buffer
    currentArrival_A = arrivalsSlottedA(frameTrackerA);
    currentArrival_B = arrivalsSlottedB(frameTrackerB);
    % what slot does each node plan on transmitting?
    endOfBackoff_A = currentArrival_A + currentBackoffA + difsDur; % random backoff
    endOfBackoff_B = currentArrival_B + currentBackoffB + difsDur; % random backoff and DIFSDUR
    % also, when would the planned transmission end? --> whenever they
    % start + NAV
    if vcsFlag ==1
        endNav_A = endOfBackoff_A + NAV + RTS; % account for extra RTS
        endNav_B = endOfBackoff_B + NAV + RTS;        
    else
        endNav_A = endOfBackoff_A + NAV;
        endNav_B = endOfBackoff_B + NAV;
    end
end


function writeDataToFile(lambdaChosen, transmissionLog,dataFrameBits,  numCollisions, vcsFlag, frameTrackerA, frameTrackerB)
    %%% Store data aquired for this round in text file, to be plotted later :
    % 1. throughput (kbps) vs rate (lambda frames/sec)
    totalSimulationTime = transmissionLog{end,7};
    %throughput = amountOfData / amountOfTime = numFrames*sizeFrame/simTime
    throughputA = (frameTrackerA) * dataFrameBits/ totalSimulationTime; 
    throughputB = (frameTrackerB) * dataFrameBits/ totalSimulationTime; 
    % determine fairness
    biasTowardA = transmissionLog{end,11}/transmissionLog{end,12};
    % fairness due to clipping sim time
    biasTowardAClip = transmissionLog{end,9}/transmissionLog{end,10};
    if vcsFlag == 1
        fileID = fopen('SingleDomain_withVCS.txt', 'a');
    else
        fileID = fopen('SingleDomain.txt', 'a');
    end
    % Write values and a newline character
    fprintf(fileID, 'lambda:,  throughputA:, throughputB, collisions: , Node A Bias backoffRace, Node A Bias runClip:\n');
    fprintf(fileID, '%d,  %d,  %d, %d, %d, %d\n', lambdaChosen, throughputA, throughputB, numCollisions, biasTowardA, biasTowardAClip );
    fclose('all');
end