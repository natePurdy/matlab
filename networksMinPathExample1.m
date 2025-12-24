%% network_routing_fixed.m
clear; clc;

%% --- Define Network ---
nodes = {'A','B','C','D','E','F'};

costs = [ 0   1   3   4  Inf  Inf;  % A
          1   0   3  Inf  10   4;   % B
          3   3   0   1  Inf  Inf;  % C
          4  Inf   1   0   4  Inf;  % D
        Inf  10  Inf   4   0   1;   % E
        Inf   4  Inf  Inf   1   0]; % F

startNode = 'E';
startIdx = find(strcmp(nodes, startNode));

%% --- Initialize ---
numNodes = length(nodes);
visited = false(1, numNodes);
dist = Inf(1, numNodes);
prev = NaN(1, numNodes);
dist(startIdx) = 0;

fprintf('Dijkstra''s Algorithm starting from node %s:\n\n', startNode);

for i = 1:numNodes
    % Select unvisited node with minimum tentative distance
    unvisited = find(~visited);
    [~, idxMin] = min(dist(unvisited));
    u = unvisited(idxMin);

    if isinf(dist(u))
        break; % No more reachable nodes
    end

    visited(u) = true;
    fprintf('Step %d: Added node %s to known set.\n', i, nodes{u});

    % Relax neighbors
    for v = 1:numNodes
        if ~visited(v) && costs(u,v) < Inf
            alt = dist(u) + costs(u,v);
            if alt < dist(v)
                dist(v) = alt;
                prev(v) = u;
            end
        end
    end

    % Print updated distances
    fprintf('  Updated distances after adding %s:\n', nodes{u});
    for n = 1:numNodes
        if isinf(dist(n))
            fprintf('    %s: Inf\n', nodes{n});
        else
            fprintf('    %s: %.2f\n', nodes{n}, dist(n));
        end
    end
    fprintf('\n');
end

%% --- Display Final Shortest Paths ---
fprintf('\nFinal Shortest Paths from %s:\n', startNode);
for n = 1:numNodes
    if n == startIdx, continue; end
    if isinf(dist(n))
        fprintf('  No path to %s\n', nodes{n});
        continue;
    end
    path = n;
    while ~isnan(prev(path(1)))
        path = [prev(path(1)) path];
    end
    pathStr = strjoin(nodes(path), ' → ');
    fprintf('  %s (cost = %.2f)\n', pathStr, dist(n));
end

%% --- Forwarding Table at Node B ---
fprintf('\n--- Forwarding Table at Node B ---\n');
B_idx = find(strcmp(nodes, 'B'));
fprintf('Destination | Next Hop | Cost\n');
fprintf('------------|-----------|------\n');

for d = 1:numNodes
    if d == B_idx, continue; end
    neighbors = find(costs(B_idx,:) < Inf & (1:numNodes) ~= B_idx);
    bestCost = Inf;
    bestHop = '-';
    for nh = neighbors
        alt = costs(B_idx, nh) + dist(nh);
        if alt < bestCost
            bestCost = alt;
            bestHop = nodes{nh};
        end
    end
    fprintf('     %s       |     %s     |  %.2f\n', nodes{d}, bestHop, bestCost);
end


%% =====================================================
%  PART 2: DISTANCE VECTOR ALGORITHM (Add-on Problem)
%  =====================================================
fprintf('\n\n==============================================\n');
fprintf('DISTANCE VECTOR ALGORITHM SIMULATION\n');
fprintf('==============================================\n\n');

% --- Initialization ---
DV = costs;            % Each node's distance vector (initially, direct links)
nextHop = cell(numNodes, numNodes);

for i = 1:numNodes
    for j = 1:numNodes
        if i == j
            nextHop{i,j} = '-';
        elseif costs(i,j) < Inf
            nextHop{i,j} = nodes{j};
        else
            nextHop{i,j} = '-';
        end
    end
end

% --- Distance Vector Iterations ---
changed = true;
iteration = 0;

while changed
    changed = false;
    iteration = iteration + 1;

    fprintf('\nIteration %d:\n', iteration);
    
    % Show current tables before update
    for i = 1:numNodes
        fprintf('  Node %s table before update:\n', nodes{i});
        fprintf('    Dest | Cost | NextHop\n');
        fprintf('    ----------------------\n');
        for j = 1:numNodes
            fprintf('     %s   | %4s | %s\n', nodes{j}, ...
                num2str(DV(i,j),'%.1f'), nextHop{i,j});
        end
        fprintf('\n');
    end

    % --- Each node updates its table using Bellman-Ford rule ---
    for i = 1:numNodes
        for j = 1:numNodes
            if i == j, continue; end
            % Try all neighbors k
            for k = 1:numNodes
                if costs(i,k) < Inf && k ~= i
                    newCost = costs(i,k) + DV(k,j);
                    if newCost < DV(i,j)
                        DV(i,j) = newCost;
                        nextHop{i,j} = nodes{k};
                        changed = true;
                    end
                end
            end
        end
    end
end

fprintf('\n--- Final Distance Vectors (after convergence) ---\n');
for i = 1:numNodes
    fprintf('\nNode %s:\n', nodes{i});
    fprintf('  Dest | Cost | NextHop\n');
    fprintf('  ----------------------\n');
    for j = 1:numNodes
        fprintf('   %s   | %4s | %s\n', nodes{j}, ...
            num2str(DV(i,j),'%.1f'), nextHop{i,j});
    end
end

fprintf('\nAlgorithm converged after %d iterations.\n', iteration);