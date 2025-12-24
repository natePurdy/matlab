function [ef_intensity] = my_phased_array(eNaught,N,theta,theta_naught,d,lambda)

ef_intensity = eNaught*sin(N*(pi*d/lambda))*(sin(theta)-sin(theta_naught))/(sin(pi*d/lambda)*(sin(theta)-sin(theta_naught)));

end