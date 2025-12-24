% for calculating probability or covariance of two jointly normal RV's
clear; close all;

ux = 1; varX = 1; uy = 0; varY = 4; p = 0.5;
uvect = [ux; uy];
sigX = sqrt(varX); % std devs
sigY = sqrt(varY);

% Linear combination parameters
%transform using P(.)
pvect = [2 1] % 2x + 1Y <= some_value
muZ = pvect*uvect
covariance = p*sqrt(varX*varY)
varZ = pvect(1)^2*varX + pvect(2)^2*varY + 2*pvect(1)*pvect(2)*p*sigX*sigY
sigZ = sqrt(varZ); % new standart deviation

% Compute probability (left sided) --> P(2X+Y <=3)
probeValue = 3;
zscore = (probeValue-muZ)/sigZ;   % your z-score
prob = normcdf(zscore);

fprintf('P(2X + Y <= 3) = %.4f\n', prob);

% what about the Cov(X+Y, 2X-Y) ?
% Define coefficient vectors for the linear combinations
a = [1 1];   % Z1 = X + Y
b = [2 -1];  % Z2 = 2X - Y

% Compute covariance using matrix form
Sigma = [varX, covariance; covariance, varY];
cov_Z1Z2 = a * Sigma * b';   % Cov(Z1, Z2)

fprintf('Cov(X+Y, 2X-Y) = %.4f\n', cov_Z1Z2);


%%% what about P(Y>1 | X=2)
% new mean 
% E(Y> 1 | x=2)
Y = 1; % use this for phi function
x = 2;
eYgivenX = uy + p*sigY*(x-ux)/sigX
varYgivenX = (1-p^2)*varY
zscore = (Y-eYgivenX)/sqrt(varYgivenX);   % your z-score
probGivenX = 1 - normcdf(zsco      re)