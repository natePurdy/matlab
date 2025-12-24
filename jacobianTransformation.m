%% compute_joint_pdf_ZW.m
% Computes the joint PDF f_ZW(z,w) of Z = X + Y, W = X - Y
% for X,Y ~ Uniform(0,1), independent, using Jacobian

clear; clc; close all;
syms x y z w real

%% Step 1: Define transformation
z = x + y;
w = x - y;



%% Step 2: Compute Jacobian symbolically
J = jacobian([z, w], [x, y]);   % 2x2 Jacobian matrix:  [taking derivatives of these], [with respect to these]
JacobianDet = abs(det(J));      % absolute value of determinant
disp('Jacobian determinant |J| =');
disp(JacobianDet);

%% Step 3: Define joint pdf of X and Y
fyy = 1; fxx = 1;
fxy = fyy*fxx; % multiply the two independent uniform marginals 
% now use that transformation on t he known joint pdf
pdf_zw = (1/abs(JacobianDet)) * fxy 