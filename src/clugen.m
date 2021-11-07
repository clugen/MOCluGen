function [points, point_clusters, point_projections, cluster_sizes, ...
    cluster_centers, cluster_directions, cluster_angles, cluster_lengths] = ...
    clugen( ...
        num_dims, ...
        num_clusters, ...
        num_points, ...
        direction, ...
        angle_disp, ...
        cluster_sep, ...
        llength, ...
        llength_disp, ...
        lateral_disp, ...
        varargin ...
    )
% CLUGEN Generates multidimensional data for clustering. Data is created
%        along straight lines, which can be more or less parallel
%        depending on the dirStd parameter.
%
% [points, cluster_sizes, point_clusters, cluster_centers, cluster_directions, cluster_lengths] =
%    CLUGEN(num_dims, num_clusters, num_points, direction, angle_disp, ...
%           cluster_sep,  llength, llength_disp, lateral_disp, ...)
%
% Required input parameters
% -------------------------
%
% num_dims
%     Number of dimensions (integer).
% num_clusters
%     Number of clusters to generate (integer).
% num_points
%     Total points in generated data (integer). These will be randomly
%     divided between clusters using the half-normal distribution with unit
%     standard deviation.
% direction
%     Main direction of clusters (num_dims x 1 vector).
% angle_disp
%     Standard deviation of cluster-supporting line angles (float).
% cluster_sep
%     Mean cluster separation (num_dims x 1 vector).
% llength
%     Mean length of cluster-supporting lines (integer).
% llength_disp
%     Standard deviation of the length of cluster-supporting lines (float).
% lateral_disp
%     Point dispersion from line, i.e. "cluster fatness" (integer).
%
% Optional named input parameters
% -------------------------------
%
% allow_empty
%    Allow empty clusters? This value is false by default (bool).
% point_dist
%    Specifies the distribution of points along lines, with two possible
%    values:
%    - 'norm' (default) distribute points along lines using a normal
%      distribution (line center is the mean and the line length is equal
%      to 3 standard deviations).
%    - 'unif' distributes points uniformly along lines.
%    - User-defined function which accepts length of line and number of points,
%      and returns a num_dims x 1 vector.
% point_offset
%    Controls how points are created from their projections on the lines,
%    with two possible values:
%    - 'd-1' (default) places points on a second line perpendicular to the
%      cluster-supporting line using a normal distribution centered at their
%      intersection.
%    - 'd' (default) places point using a multivariate normal distribution
%      centered at the point projection.
%    - Used-defined function which accepts point projections on the line
%      (num_points x num_dims), lateral_disp, cluster direction (num_dims x 1)
%      and cluster center (num_dims x 1), and returns a matrix containing the
%      final points for the current cluster (num_points x num_dims).
% cluster_offset
%    Offset to add to all cluster centers. By default equal to
%    zeros(num_dims, 1).
%
% Outputs
% -------
%
% points
%     Matrix (num_points x num_dims) with the generated data.
% cluster_sizes
%     Vector (num_clusters x 1) containing number of points in each cluster.
% point_clusters
%     Vector (num_points x 1) containing the cluster indices of each
%     point.
% cluster_centers
%     Matrix (num_clusters x num_dims) containing cluster centers, or more
%     specifically, the centers of the cluster-supporting lines.
% cluster_directions
%     Vector (num_clusters x num_dims) containing the vectors which define the
%     angle cluster-supporting lines.
% cluster_lengths
%     Vector (num_clusters x 1) containing the lengths of the cluster-supporting
%     lines.
% point_projections
%     Coordinates of point projections on the cluster-supporting lines
%
% Usage example
% -------------
%
%   [points, np, point_clusters] = clugen(3, 4, 1000, [1 0 0], 0.1, [20 15 35], 12, 4, 0.5);
%
% This creates 4 clusters in 3D space with a total of 1000 points, with a
% main direction of [1 0 0] (along the x-axis), with an angle standard
% deviation of 0.1, average cluster separation of [20 15 35], mean length
% of cluster-supporting lines of 12 (std of 4), and lateral_disp of 0.5.
%
% The following command plots the generated clusters:
%
%   scatter3(points(:, 1), points(:, 2), points(:,3), 8, point_clusters);
%
% Reference (TODO Update with new paper):
% Fachada, N., & Rosa, A. C. (2020). generateData—A 2D data generator.
% Software Impacts, 4:100017. doi: 10.1016/j.simpa.2020.100017

    % %%%%%%%%%%%%%%% %
    % Validate inputs %
    % %%%%%%%%%%%%%%% %

    % Known distributions for sampling points along lines
    point_dists = {'norm', 'unif'};
    point_offsets = {'d-1', 'd'};

    % Setup input validation
    p = inputParser;
    % Check that number of dimensions is more than zero
    addRequired(p, 'num_dims', ...
        @(x) isnumeric(x) && isscalar(x) && (x > 0) && (mod(x, 1) == 0));
    % Check that number of clusters is more than zero
    addRequired(p, 'num_clusters', ...
        @(x) isnumeric(x) && isscalar(x) && (x > 0) && (mod(x, 1) == 0));
    % Check that num_points is more than zero
    addRequired(p, 'num_points', ...
        @(x) isnumeric(x) && isscalar(x) && (x > 0) && (mod(x, 1) == 0));
    % Check that direction has num_dims dimensions and magnitude > 0
    addRequired(p, 'direction', ...
        @(x) isnumeric(x) && all(size(x) == [num_dims 1]) && norm(x) > eps);
    % Check that angle_disp is a scalar
    addRequired(p, 'angle_disp', ...
        @(x) isnumeric(x) && isscalar(x));
    % Check that cluster_sep has num_dims dimensions
    addRequired(p, 'cluster_sep', ...
        @(x) isnumeric(x) && all(size(x) == [num_dims 1]));
    % Check that llength is a scalar
    addRequired(p, 'llength', ...
        @(x) isnumeric(x) && isscalar(x) && (x >= 0));
    % Check that llength_disp is a scalar
    addRequired(p, 'llength_disp', ...
        @(x) isnumeric(x) && isscalar(x) && (x >= 0));
    % Check that lateral_disp is a scalar
    addRequired(p, 'lateral_disp', ...
        @(x) isnumeric(x) && isscalar(x) && (x >= 0));
    % If given, cluster_offset must have the correct number of dimensions,
    % if not given then it will be a num_dims x 1 vector of zeros
    addParameter(p, 'cluster_offset', zeros(num_dims, 1), ...
        @(x) isnumeric(x) && all(size(x) == [num_dims 1]));
    % Check that allow_empty is a boolean
    addParameter(p, 'allow_empty', false, ...
        @(x) isscalar(x) && isa(x, 'logical'));
    % Check that point_dist specifies a valid way for projecting points along
    % cluster-supporting lines, i.e., either 'norm' (default), 'unif' or a
    % user-defined function
    addParameter(p, 'point_dist', point_dists{1}, ...
        @(x) isa(x, 'function_handle') || any(validatestring(x, point_dists)));
    % Check that point_offset specifies a valid way for generating points given
    % their projections along cluster-supporting lines, i.e., either 'd-1'
    % (default), 'd' or a user-defined function
    addParameter(p, 'point_offset', point_offsets{1}, ...
        @(x) isa(x, 'function_handle') || any(validatestring(x, point_offsets)));

    % Perform input validation and parsing
    parse(p, num_dims, num_clusters, num_points, direction, angle_disp, ...
        cluster_sep, llength, llength_disp, lateral_disp, varargin{:});

    % If allow_empty is false, make sure there are enough points to distribute
    % by the clusters
    if ~p.Results.allow_empty && num_points < num_clusters
        error(['Number of points must be equal or larger than the ' ...
            'number of clusters. Set ''allow_empty'' to true to allow ' ...
            'for empty clusters.']);
    end;

    % What distribution to use for point projections along cluster-supporting lines?
    if isa(p.Results.point_dist, 'function_handle')
        % Use user-defined distribution; assume function accepts length of line
        % and number of points, and returns a num_dims x 1 vector
        pointproj_fn = p.Results.point_dist;
    elseif strcmp(p.Results.point_dist, 'unif')
        % Point projections will be uniformly placed along cluster-supporting lines
        pointproj_fn = @(len, n) len * rand(n, 1) - len / 2;
    elseif strcmp(p.Results.point_dist, 'norm')
        % Use normal distribution for placing point projections along cluster-supporting
        % lines, mean equal to line center, standard deviation equal to 1/6 of line length
        pointproj_fn = @(len, n) len * randn(n, 1) / 6;
    else
        % We should never get here
        error('Invalid program state');
    end;

    % What distribution to use for placing points from their projections?
    if num_dims == 1
        % If 1D was specified, point projections are the points themselves
        pt_from_proj_fn = @(projs, lat_disp, len, clu_dir, clu_ctr) projs;
    elseif isa(p.Results.point_offset, 'function_handle')
        % Use user-defined distribution; assume function accepts point projections
        % on the line, lateral std., cluster direction and cluster center, and
        % returns a num_points x num_dims matrix containing the final points
        % for the current cluster
        pt_from_proj_fn = p.Results.point_offset;
    elseif strcmp(p.Results.point_offset, 'd-1')
        % Points will be placed on a second line perpendicular to the cluster
        % line using a normal distribution centered at their intersection
        pt_from_proj_fn = @clupoints_n_1;
    elseif strcmp(p.Results.point_offset, 'd')
        % Points will be placed using a multivariate normal distribution
        % centered at the point projection
        pt_from_proj_fn = @clupoints_n;
    else
        % We should never get here
        error('Invalid program state');
    end;

    % %%%%%%%%%%%%%%%%%%%%%%%%%%%% %
    % Determine cluster properties %
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%% %

    % Normalize direction
    direction = direction / norm(direction);

    % Determine cluster sizes
    cluster_sizes = clusizes(num_clusters, num_points, p.Results.allow_empty);

    % Determine cluster centers
    cluster_centers = clucenters(num_clusters, cluster_sep, p.Results.cluster_offset);

    % Determine length of lines supporting clusters
    cluster_lengths = llengths(num_clusters, llength, llength_disp);

    % Obtain angles between main direction and cluster-supporting lines
    cluster_angles = angle_deltas(num_clusters, angle_disp);

    % Determine normalized cluster direction
    cluster_directions = zeros(num_clusters, num_dims);
    for i = 1:num_clusters
        cluster_directions(i, :) = rand_vector_at_angle(direction, cluster_angles(i));
    end;

    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
    % Determine points for each cluster %
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %

    % Aux. vector with cumulative sum of number of points in each cluster
    cumsum_points = [0; cumsum(cluster_sizes)];

    % Pre-allocate data structures for holding cluster info and points
    point_clusters = zeros(num_points, 1);        % Cluster indices of each point
    point_projections = zeros(num_points, num_dims); % Point projections on cluster-supporting lines
    points = zeros(num_points, num_dims);      % Final points to be generated

    % Loop through cluster and create points for each one
    for i = 1:num_clusters

        % Start and end indexes for points in current cluster
        idx_start = cumsum_points(i) + 1;
        idx_end = cumsum_points(i + 1);

        % Update cluster indices of each point
        point_clusters(idx_start:idx_end) = i;

        % Determine distance of point projections from the center of the line
        ptproj_dist_center = pointproj_fn(cluster_lengths(i), cluster_sizes(i));

        % Determine coordinates of point projections on the line using the
        % parametric line equation (this works since cluster direction is normalized)
        point_projections(idx_start:idx_end, :) =  points_on_line(...
            cluster_centers(i, :)', cluster_directions(i, :)', ptproj_dist_center);

        % Determine points from their projections on the line
        points(idx_start:idx_end, :) = pt_from_proj_fn( ...
            point_projections(idx_start:idx_end, :), lateral_disp, cluster_lengths(i), ...
            cluster_directions(i, :)', cluster_centers(i, :)');

    end;

end % function

% Copyright (c) 2012-2021 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy
% at http://opensource.org/licenses/MIT)