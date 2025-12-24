% optical communication system design

% what is the distance from A to B
lengthAB = 3380; % km

% 2 equations, 2 unknowns 
% L1 + L2 = LengthAB /// total length requierment
% D1*L1+ D2*L2 = 0   /// total dispersion requirement


% What is the transmission fiber and does it need compensation?
D1 = 17; % ps/nm-km dispersion of transmission fiber
D2 = -38; %ps/nm-km dispersion of compensation fiber
% given the dispersion of the transmission line, and total length, how much
% length should the compensation line be
L2 = -D1*lengthAB/(D2-D1)
% now use the other equation
L1 = lengthAB - L2

% number of lines required is determined by the data rate requirement
LineMaxDataRate = 100e9; % 100 Gbps
dataRateRequirement = 1e12;  % 1 THz
numLinesNeeded = dataRateRequirement/LineMaxDataRate

% how many frequency/intensity modulator will we need? one for each frequency or
% weavelength, and how ever many per line to achive the full line data rate
FreqModMaxRate = 10e9; % max data rate of each modulator
numModulatorsTotal = numLinesNeeded*(LineMaxDataRate/FreqModMaxRate)


% assuming all the light from the supply laser enters the 10 lines...
powerLaserSupplied = 10e-3; % 10 mW
PowerPerFiber = powerLaserSupplied/ numLinesNeeded

% Minimum detectablilty
ADP_sensitivity_dB = -27; % dB
ADP_sensitivity_mW = 10^(ADP_sensitivity_dB/10)
ADP_sensitivity_W = ADP_sensitivity_mW*10^-3


% assume power has elaready degreaded to minimum detactable power after
% modulation and such (begining of transmission fiber)
% amplifier saturation is limiting, especially if EDFA
ApmlifierSaturationPower = 200e-6; % 200uW maximum output power of EDFA
maxSaturationGain = 200e-6 / ADP_sensitivity_W

% max saturation amplifier gain
maxAmpGain_dB = 10*log10(maxSaturationGain)

% distance between EDFA's to keep signal above minimum detectable level
% what is the fibers loss? SMF28 is 0.19dB/km
fiberLoss_dB = 0.19; % dB/km
EDFA_seperation_line1 = maxAmpGain_dB/fiberLoss_dB
numEDFAS_line1 = ceil(L1/EDFA_seperation_line1)
% fudge factor for individual EDFA loss
lossPerEDFA_dB = 2;
lossForAllEDFA_line1_dB = numEDFAS_line1 * lossPerEDFA_dB;
fudgeNumNeeded_line1 = ceil(lossForAllEDFA_line1_dB/maxAmpGain_dB)
totalEDFA1 = fudgeNumNeeded_line1 +numEDFAS_line1;

% compesnation fiber will have different loss
fiberLoss2_dB = 0.235; % dB/km
EDFA_seperation_line2 = maxAmpGain_dB/fiberLoss2_dB
numEDFAS_line2 = ceil(L2/EDFA_seperation_line2)
% fudge factor for individual EDFA loss
lossPerEDFA_dB = 2;
lossForAllEDFA_line2_dB = numEDFAS_line2 * lossPerEDFA_dB;
fudgeNumNeeded_line2 = ceil(lossForAllEDFA_line2_dB/maxAmpGain_dB)
totalEDFA2 = fudgeNumNeeded_line2 +numEDFAS_line2;
TotalEDFAsNeeded = totalEDFA1 + totalEDFA2


% will also need to reconstruct the signal every so often due to APD SNR
% degredation


% number of signal reconstruction required to keep the SNR 0
initialSNR = 40; % dB assumed
dbLossPerEDFA = 5;

numEDFAsPerReconstructor = initialSNR/ dbLossPerEDFA

% need modulators at the Tx and Rx side of network
mumModulatorsTotal = numModulatorsTotal*2; 
% total APD's needed
numAPDsTotal = numModulatorsTotal
% total lasers needed (for Tx/Rx signal, and for EDFA's)
% if using beam splitter for Tx, only need 1 laser to generate n signals
% (or add n + n for numbe of lines if using one laser per line)
numLasersNeeded = TotalEDFAsNeeded + 1 + 1



% now to figure out the costs... if interested
costTransFiber = 0.1*1000; % dollars per meter --> dollars per km
cost_transFiberTotal = L1*costTransFiber
costCompFiber = 0.2*1000; % dollars per meter --> dollars per km
cost_compFiberTotal = L2*costCompFiber

costPerLaser = 100; %dollars
totalCostLasers = numLasersNeeded*costPerLaser

costPerAPD = 20; %dollars
totalCostAPD = numAPDsTotal*costPerAPD

costPerEDFA = 1000; % dollars
totalCostEDFA = TotalEDFAsNeeded*costPerEDFA

costPerModulator = 100; % dollars
totalCostModulators = mumModulatorsTotal * costPerModulator


% rough total project estimate 
totalTOTAL = totalCostLasers + totalCostAPD + totalCostEDFA + cost_transFiberTotal...
    + cost_compFiberTotal + totalCostModulators