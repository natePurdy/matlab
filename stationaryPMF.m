%% Markov Chain Visualization and Stationary Distribution

clc; clear; close all;

% Define the transition matrix
P = [0 1/3 0 2/3; 
     0 1 0 0; 
     0 1/3 0 2/3;
     1/3 0 2/3 0];

n = size(P,1);  % number of states

%% 1. Visualize state transition diagram
% Create a directed graph with weighted edges
s = []; t = []; weights = [];

for i = 1:n
    for j = 1:n
        if P(i,j) > 0
            s = [s i];  % source
            t = [t j];  % target
            weights = [weights P(i,j)];  % edge weight
        end
    end
end

G = digraph(s, t, weights);

% Plot the graph
figure('Name','Markov Chain State Transition Diagram');
h = plot(G,'Layout','circle','EdgeLabel',G.Edges.Weight);
title('State Transition Diagram of the Markov Chain');

%% 2. Compute stationary distribution
% Solve pi*P = pi  <=> (P' - I')*pi' = 0 with sum(pi)=1
A = [P' - eye(n); ones(1,n)];
b = [zeros(n,1); 1];

pi = A\b;

disp('Stationary distribution:');
disp(pi);

% givem that the states are the websites visited by the user, and the state transition matrix P has already been found (above)
% find the probability that the web surfer views page i after a sufficiently long time surfing the web.
% THIS IS IN THE PI MATRIX ABOVE...

% find the stationary PMF and determine where it is unique