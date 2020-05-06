function [data, clustPoints, idx, centers, slopes, lengths] = ...
    generateData( ...
        slopeMean, ...
        slopeStd, ...
        numClusts, ...
        xClustAvgSep, ...
        yClustAvgSep, ...
        lengthMean, ...
        lengthStd, ...
        lateralStd, ...
        totalPoints, ...
        linePtsDist ...
    )
% GENERATEDATA Generates 2D data for clustering. Data is created along 
%              straight lines, which can be more or less parallel
%              depending on the slopeStd parameter.
%
% [data clustPoints idx centers slopes lengths] = 
%    GENERATEDATA(slopeMean, slopeStd, numClusts, xClustAvgSep, ...
%                 yClustAvgSep, lengthMean, lengthStd, lateralStd, ...
%                 totalPoints)
%
% Inputs:
%    slopeMean - Mean slope of the lines on which clusters are based.
%                Line slopes are drawn from the normal distribution.
%     slopeStd - Standard deviation of line slopes.
%    numClusts - Number of clusters (and therefore of lines) to generate.
% xClustAvgSep - Average separation of line centers along the X axis.
% yClustAvgSep - Average separation of line centers along the Y axis.
%   lengthMean - Mean length of the lines on which clusters are based.
%                Line lengths are drawn from the folded normal
%                distribution.
%    lengthStd - Standard deviation of line lengths.
%   lateralStd - "Cluster fatness", i.e., the standard deviation of the 
%                distance from each point to the respective line, in both
%                x and y directions. This distance is obtained from the 
%                normal distribution with zero mean.
%  totalPoints - Total points in generated data. These will be randomly
%                divided between clusters using the half-normal
%                distribution with unit standard deviation.
%  linePtsDist - Optional parameter which specifies the distribution of
%                points along lines. Possible values are 'unif' (default)
%                and 'norm'. The former will distribute points uniformly
%                along lines, while the latter will use a normal
%                distribution (mean equal to the line center, standard
%                deviation equal to one sixth of the line length). In the
%                latter case, the line includes three standard deviations
%                of the normal distribution, meaning that there is a small
%                chance that some points are projected outside line
%                limits.
%
% Outputs:
%         data - Matrix (totalPoints x 2) with the generated data.
%  clustPoints - Vector (numClusts x 1) containing number of points in
%                each cluster.
%          idx - Vector (totalPoints x 1) containing the cluster indices
%                of each point.
%      centers - Matrix (numClusts x 2) containing centers from where
%                clusters were generated.
%       slopes - Vector (numClusts x 1) containing the effective slopes 
%                of the lines used to generate clusters.
%      lengths - Vector (numClusts x 1) containing the effective lengths 
%                of the lines used to generate clusters.
%
% ----------------------------------------------------------
% Usage example:
%
%   [data cp idx] = GENERATEDATA(1, 0.5, 5, 15, 15, 5, 1, 2, 200);
%
% This creates 5 clusters with a total of 200 points, with a mean slope 
% of 1 (std=0.5), separated in average by 15 units in both x and y 
% directions, with mean length of 5 units (std=1) and a "fatness" or
% spread of 2 units.
%
% The following command plots the generated clusters:
%
%   scatter(data(:,1), data(:,2), 8, idx);

% Copyright (c) 2012-2020 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)

% Make sure totalPoints >= numClusts
if totalPoints < numClusts
    error('Number of points must be equal or larger than the number of clusters.');
end;

% Check if linePtsDist was specified
if (~exist('linePtsDist', 'var'))
    linePtsDist = 'unif';
end;
if strcmp(linePtsDist, 'unif')
    distfun = @(len, n) len * rand(n, 1) - len / 2;
elseif strcmp(linePtsDist, 'norm')
    distfun = @(len, n) len * randn(n, 1) / 6;
else
    error(['Unknown distribution "' linePtsDist '"']);
end;

% Determine number of points in each cluster using the half-normal
% distribution (with std=1)
clustPoints = abs(randn(numClusts, 1));
clustPoints = clustPoints / sum(clustPoints);
clustPoints = round(clustPoints * totalPoints);

% Make sure totalPoints is respected
while sum(clustPoints) < totalPoints
    % If one point is missing add it to the smaller cluster
    [C, I] = min(clustPoints);
    clustPoints(I(1)) = C + 1;
end;
while sum(clustPoints) > totalPoints
    % If there is one extra point, remove it from larger cluster
    [C, I] = max(clustPoints);
    clustPoints(I(1)) = C - 1;
end;

% Make sure there are no empty clusters
emptyClusts = find(clustPoints == 0);
if ~isempty(emptyClusts)
    % If there are empty clusters...
    numEmptyClusts = size(emptyClusts, 1);
    for i = 1:numEmptyClusts
        % ...get a point from the largest cluster and assign it to the
        % empty cluster
        [C, I] = max(clustPoints);
        clustPoints(I(1)) = C - 1;
        clustPoints(emptyClusts(i)) = 1;
    end;
end;

% Obtain the cumulative sum vector of point counts in each cluster
cumSumPoints = [0; cumsum(clustPoints)];

% Initialize data matrix
data = zeros(sum(clustPoints), 2);

% Initialize idx (vector containing the cluster indices of each point)
idx = zeros(totalPoints, 1);

% Determine cluster centers
xCenters = xClustAvgSep * numClusts * (rand(numClusts, 1) - 0.5);
yCenters = yClustAvgSep * numClusts * (rand(numClusts, 1) - 0.5);
centers = [xCenters yCenters];

% Determine cluster slopes
slopes = slopeMean + slopeStd * randn(numClusts, 1);

% Determine length of lines where clusters will be formed around
% Line lengths are drawn from the folded normal distribution
lengths = abs(lengthMean + lengthStd * randn(numClusts, 1));

% Create clusters
for i = 1:numClusts

    % Determine where in the line this cluster's points will be projected
    % using the specified distribution (i.e. points will be projected
    % along the line using either the uniform or normal distribution)
    positions = distfun(lengths(i), clustPoints(i));

    % Determine x coordinates of point projections
    deltas_x = cos(atan(slopes(i))) * positions;

    % Determine y coordinates of point projections
    deltas_y = deltas_x * slopes(i);

    % Get point distances from line in x coordinate
    deltas_x = deltas_x + lateralStd * randn(clustPoints(i), 1);

    % Get point distances from line in y coordinate
    deltas_y = deltas_y + lateralStd * randn(clustPoints(i), 1);

    % Determine the actual points
    data(cumSumPoints(i) + 1 : cumSumPoints(i + 1), :) = ...
        [(xCenters(i) + deltas_x) (yCenters(i) + deltas_y)];

    % Update idx
    idx(cumSumPoints(i) + 1 : cumSumPoints(i + 1)) = i;
end;