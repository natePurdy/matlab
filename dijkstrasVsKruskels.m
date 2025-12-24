%% network_routing_fixed_with_kruskal.m
clear; clc;

%% --- Define Network ---
nodes = {'A','B','C','D','E','F'};

costs = [ 0   -3   Inf  Inf  Inf   1;   % A
         -3   0   3     2   15   6;   % B
          Inf 3   0     9   Inf  Inf;  % C
          Inf 2   9     0    6   Inf;  % D
          Inf 15  Inf   6    0   12;   % E
          1   6   Inf  Inf  12   0];  % F

startNode = 'F';
startIdx = find(strcmp(nodes, startNode));

%% ============================================================
%  PART 1: DIJKSTRA'S ALGORITHM (as in your original code)
%  ============================================================
numNodes = length(nodes);
visited = false(1, numNodes);
dist = Inf(1, numNodes);
prev = NaN(1, numNodes);
dist(startIdx) = 0;

fprintf('Dijkstra''s Algorithm starting from node %s:\n\n', startNode);

for i = 1:numNodes
    unvisited = find(~visited);
    [~, idxMin] = min(dist(unvisited));
    u = unvisited(idxMin);

    if isinf(dist(u)), break; end
    visited(u) = true;

    fprintf('Step %d: Added node %s to known set.\n', i, nodes{u});

    for v = 1:numNodes
        if ~visited(v) && costs(u,v) < Inf
            alt = dist(u) + costs(u,v);
            if alt < dist(v)
                dist(v) = alt;
                prev(v) = u;
            end
        end
    end

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


%% ============================================================
%  PART 2: KRUSKAL'S ALGORITHM FOR MINIMUM SPANNING TREE
%  ============================================================

fprintf('\n===========================================\n');
fprintf('KRUSKAL''S ALGORITHM - MINIMUM SPANNING TREE\n');
fprintf('===========================================\n\n');

% --- Step 1: Extract all edges with weights ---
edges = [];
for i = 1:numNodes
    for j = i+1:numNodes
        if costs(i,j) < Inf && costs(i,j) > 0
            edges = [edges; i, j, costs(i,j)];
        end
    end
end

% Sort edges by ascending weight
edges = sortrows(edges, 3);

% Each node starts as its own subtree
parent = 1:numNodes;

% Helper function: find root of a node
findRoot = @(x) ( ...
    (parent(x) == x) * x + ...
    (parent(x) ~= x) * findRoot(parent(x)) );

% Helper function: union of two sets
function unionSets(a,b)
    global parent;
    rootA = a;
    while parent(rootA) ~= rootA
        rootA = parent(rootA);
    end
    rootB = b;
    while parent(rootB) ~= rootB
        rootB = parent(rootB);
    end
    if rootA ~= rootB
        parent(rootB) = rootA;
    end
end

% --- Step 2 & 3: Add edges one-by-one (minimum first) ---
mstEdges = [];
totalCost = 0;

fprintf('Edges considered in order:\n');
disp(array2table(edges, 'VariableNames', {'Node1','Node2','Cost'}));

for k = 1:size(edges,1)
    u = edges(k,1);
    v = edges(k,2);
    w = edges(k,3);

    % Find roots of each endpoint
    rootU = u;
    while parent(rootU) ~= rootU
        rootU = parent(rootU);
    end
    rootV = v;
    while parent(rootV) ~= rootV
        rootV = parent(rootV);
    end

    % If roots are different, add this edge (avoids cycles)
    if rootU ~= rootV
        mstEdges = [mstEdges; u, v, w];
        parent(rootV) = rootU;
        totalCost = totalCost + w;
        fprintf('  Added edge (%s - %s) with cost %.1f\n', nodes{u}, nodes{v}, w);
    else
        fprintf('  Skipped edge (%s - %s) to avoid cycle\n', nodes{u}, nodes{v});
    end
end

fprintf('\n--- Final Minimum Spanning Tree ---\n');
for i = 1:size(mstEdges,1)
    fprintf('  %s - %s  (cost = %.1f)\n', nodes{mstEdges(i,1)}, nodes{mstEdges(i,2)}, mstEdges(i,3));
end
fprintf('Total cost of MST = %.1f\n', totalCost);