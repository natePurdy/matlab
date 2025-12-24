% Program to demonstrate accumulation of a function over a finite
% time using the cumsum function.
n = 0:36 ; % Discrete-time vector
x = cos(2*pi*n/36); % Values of x[n]
% Graph the accumulation of the function x[n]
p = stem(n,cumsum(x),'k','filled');
set(p,'LineWidth',2,'MarkerSize',4);
xlabel('\itn','FontName','Times','FontSize',24);
ylabel('x[{\itn}]','FontName','Times','FontSize',24);