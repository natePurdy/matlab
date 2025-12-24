close all;
clear;
% List of input files
fileList = {
    'SingleDomain.txt',
    'SingleDomain_withVCS.txt',
    'HiddenDomain.txt',
    'HiddenDomain_withVCS.txt'
};
fileListHidden = {
    'HiddenDomain.txt',
    'HiddenDomain_withVCS.txt'
};
fileListSingle = {
    'SingleDomain.txt',
    'SingleDomain_withVCS.txt'
};


% Initialize plot
figure;
hold on;
colors = lines(length(fileList));  % Distinct colors for each file
doCollisions =0;
doSingleDomain = 0;
doHiddenDomain = 0;
doThroughput = 0;
doAttemptsToTransmit = 0;
doStationBackoffBiasA = 0;
doFairness = 1;

if doSingleDomain ==1
    fileList = fileListSingle;
elseif doHiddenDomain ==1
    fileList = fileListHidden;
end
% Loop through each file
for i = 1:length(fileList)
    filename = fileList{i};
    
    % Open file
    fid = fopen(filename, 'r');
    if fid == -1
        warning('Could not open file: %s', filename);
        continue;
    end

    % Initialize data arrays for this file
    lambda = [];
    throughputA = [];
    throughputB = [];
    collisions = [];
    collisionsA = [];
    collisionsB = [];
    nodeABackoffBias = [];
    nodeARunClipBias = [];
    attemptsTransmitA = [];
    attemptsTransmitB = [];

    % Read file line-by-line
    while ~feof(fid)
        line = fgetl(fid);
        if startsWith(strtrim(line), 'lambda:')
            continue;  % Skip header lines
        end

        % Parse numerical line differently according to file contents
        [~, name, ~] = fileparts(filename);
        name = replace(name,'_', ' '); % messes up the plot
        if contains(name, 'Hidden')
            data = textscan(line, '%f %f %f %f %f %f %f %f %f', 'Delimiter', ',');
            color = 'r';
        else
            data = textscan(line, '%f %f %f %f %f %f %f', 'Delimiter', ',');
            color = 'b';
        end
        if isempty(data{1})
            continue;  % Skip invalid lines
        end

        lambda(end+1) = data{1};
        throughputA(end+1) = data{2};
        throughputB(end+1) = data{3};

        if contains(name, 'Single')
            collisions(end+1) = data{4};
            nodeABackoffBias(end+1) = data{5};
            nodeARunClipBias(end+1) = data{6};
        else
            collisionsA(end+1) = data{4};
            collisionsB(end+1) = data{5};
            attemptsTransmitA(end+1) = data{6};
            attemptsTransmitB(end+1) = data{7};
            nodeABackoffBias(end+1) = data{8};
            nodeARunClipBias(end+1) = data{9};
        end

    end

    fclose(fid);
    if contains(name, 'VCS')
        vcsTag = '-o';
    else
        vcsTag = '-';
    end
    
    % Plot throughputA vs lambda for this file
    if doThroughput==1
        figure(1)
        hold on
        plot(lambda, throughputA, vcsTag, 'LineWidth', 2, ...
            'Color', color, 'DisplayName', name);
        figure(2)
        hold on
        plot(lambda, throughputB, vcsTag, 'LineWidth', 2, ...
        'Color', color, 'DisplayName', name);
    
    
        if i==length(fileList)
            % Finalize plot
            figure(1); 
            xlabel('\lambda (Frame Arrival Rate)');
            ylabel('Throughput A (bits/sec)');
            title('Throughput A vs. \lambda');
            legend('Location', 'best');
            grid on;
            figure(2);
            xlabel('\lambda (Frame Arrival Rate)');
            ylabel('Throughput B (bits/sec)');
            title('Throughput B vs. \lambda');
            legend('Location', 'best');
            grid on;
        end
    elseif doFairness==1
        figure(1)
        hold on
        plot(lambda, nodeABackoffBias, vcsTag, 'LineWidth', 2, ...
            'Color', color, 'DisplayName', name);
        figure(2)
        hold on
        plot(lambda, nodeARunClipBias, vcsTag, 'LineWidth', 2, ...
        'Color', color, 'DisplayName', name);
    
    
        if i==length(fileList)
            % Finalize plot
            figure(1); 
            xlabel('\lambda (Frame Arrival Rate)');
            ylabel('A to B Win Ratio');
            title('A Bias Backoff vs. \lambda');
            legend('Location', 'best');
            grid on;
            figure(2);
            xlabel('\lambda (Frame Arrival Rate)');
            ylabel('A to B Win Ratio');
            title('A Bias RunClipvs. \lambda');
            legend('Location', 'best');
            grid on;
        end
   elseif doCollisions==1 && doSingleDomain==1
           figure(1)
            hold on
            plot(lambda, collisions, vcsTag, 'LineWidth', 2, ...
                'Color', color, 'DisplayName', name);

            if i==length(fileList)
                % Finalize plot
                figure(1); 
                xlabel('\lambda (Frame Arrival Rate)');
                ylabel('Collisions AP');
                title('Collisions AP vs. \lambda');
                legend('Location', 'best');
             
            end
   elseif doCollisions==1 && doHiddenDomain==1
        figure(1)
        hold on
        plot(lambda, collisionsA, vcsTag, 'LineWidth', 2, ...
            'Color', color, 'DisplayName', name);
        figure(2)
        hold on
        plot(lambda, collisionsB, vcsTag, 'LineWidth', 2, ...
            'Color', color, 'DisplayName', name);

        if i==length(fileList)
            % Finalize plot
            figure(1); 
            xlabel('\lambda (Frame Arrival Rate)');
            ylabel('Collisions A');
            title('Collisions A vs. \lambda');
            legend('Location', 'best');
            grid on;
            figure(2);
            xlabel('\lambda (Frame Arrival Rate)');
            ylabel('Collisions B');
            title('Collisions B vs. \lambda');
            legend('Location', 'best');
            grid on;
        end
    elseif doHiddenDomain && doAttemptsToTransmit
        figure(1)
        hold on
        plot(lambda, attemptsTransmitA, vcsTag, 'LineWidth', 2, ...
            'Color', color, 'DisplayName', name);
        figure(2)
        hold on
        plot(lambda, attemptsTransmitB, vcsTag, 'LineWidth', 2, ...
            'Color', color, 'DisplayName', name);

        if i==length(fileList)
            % Finalize plot
            figure(1); 
            xlabel('\lambda (Frame Arrival Rate)');
            ylabel('Trans Attempts A');
            title('Transmission Attempts A vs. \lambda');
            legend('Location', 'best');
            grid on;
            figure(2);
            xlabel('\lambda (Frame Arrival Rate)');
            ylabel('Trans Attempts B');
            title('Transmission Attempts B vs. \lambda');
            legend('Location', 'best');
            grid on;
        end
    elseif doHiddenDomain && doStationBackoffBiasA
        figure(1)
        hold on
        plot(lambda, nodeABackoffBias, vcsTag, 'LineWidth', 2, ...
            'Color', color, 'DisplayName', name);
        figure(2)
        hold on
        plot(lambda, nodeARunClipBias, vcsTag, 'LineWidth', 2, ...
            'Color', color, 'DisplayName', name);
        if i==length(fileList)
            % Finalize plot
            figure(1); 
            xlabel('\lambda (Frame Arrival Rate)');
            ylabel('Trans Attempts A');
            title('Transmission Attempts A vs. \lambda');
            legend('Location', 'best');
            grid on;
            figure(2);
            xlabel('\lambda (Frame Arrival Rate)');
            ylabel('Trans Attempts B');
            title('Transmission Attempts B vs. \lambda');
            legend('Location', 'best');
            grid on;
        end

    end
end



