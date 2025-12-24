


n = 10;
d = 0.01;
lambda = 0.0001;
theta = .02;
theta_naught = 0;
e_naught = 1;
j = sqrt(-1);
E = 0;

for i=1:100
    
    E = E + e_naught*exp(j*2*pi*n*d*(sin(theta)-sin(theta_naught)))/lambda;
    print(E)
end