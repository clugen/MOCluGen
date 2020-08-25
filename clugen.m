function [data, clustPoints, idx, centers, angles, lengths] = ...
    clugen( ...
        ndim, ...
        numClusts, ...
        totalPoints, ...
        dirMain, ...
        angleStd, ...
        clustSepMean, ...
        lengthMean, ...
        lengthStd, ...
        lateralStd, ...
        varargin ...
    )
% CLUGEN Generates multidimensional data for clustering. Data is created
%        along straight lines, which can be more or less parallel
%        depending on the dirStd parameter.
%
% === Documentation below is deprecated, to be updated ===
%
% [data clustPoints idx centers angles lengths] =
%    CLUGEN(angleMean, angleStd, numClusts, xClustAvgSep, ...
%           yClustAvgSep, lengthMean, lengthStd, lateralStd, ...
%           totalPoints, ...)
%
% Required input parameters:
%    angleMean - Mean angle in radians of the lines on which clusters are
%                based. Angles are drawn from the normal distribution.
%     angleStd - Standard deviation of line angles.
%    numClusts - Number of clusters (and therefore of lines) to generate.
% xClustAvgSep - Average separation of line centers along the X axis.
% yClustAvgSep - Average separation of line centers along the Y axis.
%   lengthMean - Mean length of the lines on which clusters are based.
%                Line lengths are drawn from the folded normal
%                distribution.
%    lengthStd - Standard deviation of line lengths.
%   lateralStd - Cluster "fatness", i.e., the standard deviation of the
%                distance from each point to its projection on the
%                line. The way this distance is obtained is controlled by
%                the optional 'pointOffset' parameter.
%  totalPoints - Total points in generated data. These will be randomly
%                divided between clusters using the half-normal
%                distribution with unit standard deviation.
%
% Optional named input parameters:
%   allowEmpty - Allow empty clusters? This value is false by default.
%    pointDist - Specifies the distribution of points along lines, with
%                two possible values:
%                - 'unif' (default) distributes points uniformly along
%                  lines.
%                - 'norm' distribute points along lines using a normal
%                  distribution (line center is the mean and the line
%                  length is equal to 3 standard deviations).
%  pointOffset - Controls how points are created from their projections
%                on the lines, with two possible values:
%                - 'nd-1' places points on a second line perpendicular to
%                  the cluster line using a normal distribution centered
%                  at their intersection.
%                - 'nd' (default) places point using a bivariate normal
%                  distribution centered at the point projection.
%
% Outputs:
%         data - Matrix (totalPoints x 2) with the generated data.
%  clustPoints - Vector (numClusts x 1) containing number of points in
%                each cluster.
%          idx - Vector (totalPoints x 1) containing the cluster indices
%                of each point.
%      centers - Matrix (numClusts x 2) containing centers from where
%                clusters were generated.
%       angles - Vector (numClusts x 1) containing the effective angles
%                of the lines used to generate clusters.
%      lengths - Vector (numClusts x 1) containing the effective lengths
%                of the lines used to generate clusters.
%
% ----------------------------------------------------------
% Usage example:
%
%   [data cp idx] = GENERATEDATA(pi / 2, pi / 8, 5, 15, 15, 5, 1, 2, 200);
%
% This creates 5 clusters with a total of 200 points, with a mean angle
% of pi/2 (std=pi/8), separated in average by 15 units in both x and y
% directions, with mean length of 5 units (std=1) and a "fatness" or
% spread of 2 units.
%
% The following command plots the generated clusters:
%
%   scatter(data(:, 1), data(:, 2), 8, idx);

% Copyright (c) 2012-2020 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy
% at http://opensource.org/licenses/MIT)
%
% Reference:
% Fachada, N., & Rosa, A. C. (2020). generateData—A 2D data generator.
% Software Impacts, 4:100017. doi: 10.1016/j.simpa.2020.100017

% Known distributions for sampling points along lines
pointDists = {'unif', 'norm'};
pointOffsets = {'nd', 'nd-1'};

% Perform input validation
p = inputParser;
addRequired(p, 'ndim', ...
    @(x) isnumeric(x) && isscalar(x) && (x > 0) && (mod(x, 1) == 0));
addRequired(p, 'numClusts', ...
    @(x) isnumeric(x) && isscalar(x) && (x > 0) && (mod(x, 1) == 0));
addRequired(p, 'totalPoints', ...
    @(x) isnumeric(x) && isscalar(x) && (x > 0) && (mod(x, 1) == 0));
addRequired(p, 'dirMain', @isnumeric);
addRequired(p, 'angleStd', @(x) isnumeric(x) && isscalar(x));
addRequired(p, 'clustSepMean', @isnumeric);
addRequired(p, 'lengthMean', ...
    @(x) isnumeric(x) && isscalar(x) && (x >= 0));
addRequired(p, 'lengthStd', ...
    @(x) isnumeric(x) && isscalar(x) && (x >= 0));
addRequired(p, 'lateralStd', ...
    @(x) isnumeric(x) && isscalar(x) && (x >= 0));
addParameter(p, 'clustOffset', 0, @isnumeric);
addParameter(p, 'allowEmpty', ...
    false, @(x) isscalar(x) && isa(x, 'logical'));
addParameter(p, 'pointDist', ...
    pointDists{1}, @(x) any(validatestring(x, pointDists)));
addParameter(p, 'pointOffset', ...
    pointOffsets{2}, @(x) any(validatestring(x, pointOffsets)));

parse(p, ndim, numClusts, totalPoints, dirMain, angleStd, clustSepMean, ...
    lengthMean, lengthStd, lateralStd, varargin{:});

% Check what pointDist was specified
if strcmp(p.Results.pointDist, 'unif')
    % Use uniform distribution of points along lines
    distfun = @(len, n) len * rand(n, 1) - len / 2;
elseif strcmp(p.Results.pointDist, 'norm')
    % Use normal distribution of points along lines, mean equal to line
    % center, standard deviation equal to 1/6 of line length
    distfun = @(len, n) len * randn(n, 1) / 6;
else
    % We should never get here
    error('Invalid program state');
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

% If allowEmpty is false make sure there are no empty clusters
if ~p.Results.allowEmpty

    % First, make sure there are enough points to distribute by the
    % clusters
    if totalPoints < numClusts
        error(['Number of points must be equal or larger than the ' ...
            'number of clusters. Set ''allowEmpty'' to true to allow ' ...
            'for empty clusters.']);
    end;

    % Find empty clusters
    emptyClusts = find(clustPoints == 0);

    % If there are empty clusters...
    if ~isempty(emptyClusts)

        % How many empty clusters do we have?
        numEmptyClusts = size(emptyClusts, 1);

        % Go through the empty clusters...
        for i = 1:numEmptyClusts
            % ...get a point from the largest cluster and assign it to the
            % current empty cluster
            [C, I] = max(clustPoints);
            clustPoints(I(1)) = C - 1;
            clustPoints(emptyClusts(i)) = 1;
        end;
    end;
end;

% Obtain the cumulative sum vector of point counts in each cluster
cumSumPoints = [0; cumsum(clustPoints)];

% Initialize data matrix
data = zeros(sum(clustPoints), ndim);

% Initialize idx (vector containing the cluster indices of each point)
idx = zeros(totalPoints, 1);

% Determine cluster centers
xCenters = xClustAvgSep * numClusts * (rand(numClusts, 1) - 0.5);
yCenters = yClustAvgSep * numClusts * (rand(numClusts, 1) - 0.5);
centers = [xCenters yCenters];

% Determine cluster angles
angles = angleMean + angleStd * randn(numClusts, 1);

% Determine length of lines where clusters will be formed around
% Line lengths are drawn from the folded normal distribution
lengths = abs(lengthMean + lengthStd * randn(numClusts, 1));

% Create clusters
for i = 1:numClusts

    % Determine where in the line this cluster's points will be projected
    % using the specified distribution (i.e. points will be projected
    % along the line using either the uniform or normal distribution)
    positions = distfun(lengths(i), clustPoints(i));

    % Determine (x, y) coordinates of point projections on the line
    points_x = cos(angles(i)) * positions;
    points_y = sin(angles(i)) * positions;

    if strcmp(p.Results.pointOffset, '1D')

        % Get distances from points to their projections on the line
        points_dist = lateralStd * randn(clustPoints(i), 1);

        % Get normalized vectors, perpendicular to the current line, for
        % each point
        perpAngles = angles(i) + sign(points_dist) * pi / 2;
        perpVecs = [cos(perpAngles) sin(perpAngles)];

        % Set vector magnitudes
        perpVecs = abs(points_dist) .* perpVecs;

        % Add perpendicular vectors to point projections on the line,
        % yielding point (x,y) coordinates
        points_x = points_x + perpVecs(:, 1);
        points_y = points_y + perpVecs(:, 2);

    elseif strcmp(p.Results.pointOffset, '2D')

        % Get point distances from line in x coordinate
        points_x = points_x + lateralStd * randn(clustPoints(i), 1);

        % Get point distances from line in y coordinate
        points_y = points_y + lateralStd * randn(clustPoints(i), 1);

    else
        % We should never get here
        error('Invalid program state');
    end;

    % Determine the actual points
    data(cumSumPoints(i) + 1 : cumSumPoints(i + 1), :) = ...
        [(xCenters(i) + points_x) (yCenters(i) + points_y)];

    % Update idx
    idx(cumSumPoints(i) + 1 : cumSumPoints(i + 1)) = i;
end;
