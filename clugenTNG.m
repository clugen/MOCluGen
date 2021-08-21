function [points, clust_num_points, clu_pts_idx, centers, clust_dirs, lengths, points_proj] = ...
    clugenTNG( ...
        num_dims, ...
        num_clusters, ...
        total_points, ...
        direction, ...
        angle_std, ...
        clust_sep, ...
        line_length, ...
        line_length_std, ...
        lateral_std, ...
        varargin ...
    )
% CLUGEN Generates multidimensional data for clustering. Data is created
%        along straight lines, which can be more or less parallel
%        depending on the dirStd parameter.
%
% [points, clust_num_points, clu_pts_idx, centers, clust_dirs, lengths] =
%    CLUGEN(num_dims, num_clusters, total_points, direction, angle_std, ...
%           clust_sep,  line_length, line_length_std, lateral_std, ...)
%
% Required input parameters
% -------------------------
%
% num_dims
%     Number of dimensions (integer).
% num_clusters
%     Number of clusters to generate (integer).
% total_points
%     Total points in generated data (integer). These will be randomly
%     divided between clusters using the half-normal distribution with unit
%     standard deviation.
% direction
%     Main direction of clusters (num_dims x 1 vector).
% angle_std
%     Standard deviation of cluster-supporting line angles (float).
% clust_sep
%     Mean cluster separation (num_dims x 1 vector).
% line_length
%     Mean length of cluster-supporting lines (integer).
% line_length_std
%     Standard deviation of the length of cluster-supporting lines (float).
% lateral_std
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
% point_offset
%    Controls how points are created from their projections on the lines,
%    with two possible values:
%    - 'd-1' (default) places points on a second line perpendicular to the
%      cluster line using a normal distribution centered at their
%      intersection.
%    - 'd' (default) places point using a bivariate normal distribution
%      centered at the point projection.
% cluster_offset
%    Offset to add to all cluster centers. By default equal to
%    zeros(num_dims, 1).
%
% Outputs
% -------
%
% points
%     Matrix (total_points x num_dims) with the generated data.
% clust_num_points
%     Vector (num_clusters x 1) containing number of points in each cluster.
% clu_pts_idx
%     Vector (total_points x 1) containing the cluster indices of each
%     point.
% centers
%     Matrix (num_clusters x 2) containing cluster centers, or more
%     specifically, the centers of the cluster-supporting lines.
% clust_dirs
%     Vector (num_clusters x num_dims) containing the vectors which define the
%     angle cluster-supporting lines.
% lengths
%     Vector (num_clusters x 1) containing the lengths of the cluster-supporting
%     lines.
% points_proj
%     Coordinates of point projections on the cluster-supporting lines
%
% Usage example
% -------------
%
%   [points, np, clu_pts_idx] = clugen(3, 4, 1000, [1 0 0], 0.1, [20 15 35], 12, 4, 0.5);
%
% This creates 4 clusters in 3D space with a total of 1000 points, with a
% main direction of [1 0 0] (along the x-axis), with an angle standard
% deviation of 0.1, average cluster separation of [20 15 35], mean length
% of cluster-supporting lines of 12 (std of 4), and lateral_std of 0.5.
%
% The following command plots the generated clusters:
%
%   scatter3(points(:, 1), points(:, 2), points(:,3), 8, clu_pts_idx);

% Copyright (c) 2012-2021 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy
% at http://opensource.org/licenses/MIT)
%
% Reference (TODO Update with new paper):
% Fachada, N., & Rosa, A. C. (2020). generateData—A 2D data generator.
% Software Impacts, 4:100017. doi: 10.1016/j.simpa.2020.100017

    % Known distributions for sampling points along lines
    point_dists = {'unif', 'norm'};
    point_offsets = {'d', 'd-1'};

    % Perform input validation
    p = inputParser;
    addRequired(p, 'num_dims', ...
        @(x) isnumeric(x) && isscalar(x) && (x > 0) && (mod(x, 1) == 0));
    addRequired(p, 'num_clusters', ...
        @(x) isnumeric(x) && isscalar(x) && (x > 0) && (mod(x, 1) == 0));
    addRequired(p, 'total_points', ...
        @(x) isnumeric(x) && isscalar(x) && (x > 0) && (mod(x, 1) == 0));
    addRequired(p, 'direction', ...
        @(x) isnumeric(x) && all(size(x) == [num_dims 1]));
    addRequired(p, 'angle_std', ...
        @(x) isnumeric(x) && isscalar(x));
    addRequired(p, 'clust_sep', ...
        @(x) isnumeric(x) && all(size(x) == [num_dims 1]));
    addRequired(p, 'line_length', ...
        @(x) isnumeric(x) && isscalar(x) && (x >= 0));
    addRequired(p, 'line_length_std', ...
        @(x) isnumeric(x) && isscalar(x) && (x >= 0));
    addRequired(p, 'lateral_std', ...
        @(x) isnumeric(x) && isscalar(x) && (x >= 0));
    addParameter(p, 'cluster_offset', zeros(num_dims, 1), ...
        @(x) isnumeric(x) && all(size(x) == [num_dims 1]));
    addParameter(p, 'allow_empty', false, ...
        @(x) isscalar(x) && isa(x, 'logical'));
    addParameter(p, 'point_dist', point_dists{2}, ...
        @(x) isa(x, 'function_handle') || any(validatestring(x, point_dists)));
    addParameter(p, 'point_offset', point_offsets{2}, ...
        @(x) any(validatestring(x, point_offsets)));

    parse(p, num_dims, num_clusters, total_points, direction, angle_std, ...
        clust_sep, line_length, line_length_std, lateral_std, varargin{:});

    % If allow_empty is false, make sure there are enough points to distribute
    % by the clusters
    if ~p.Results.allow_empty && total_points < num_clusters
        error(['Number of points must be equal or larger than the ' ...
            'number of clusters. Set ''allow_empty'' to true to allow ' ...
            'for empty clusters.']);
    end;

    % What distribution to use for point projections along cluster-supporting lines?
    if isa(p.Results.point_dist, 'function_handle')
        % Use user-defined distribution; assume function returns num_dims x 1 vectors
        pointproj_fun = p.Results.point_dist;
    elseif strcmp(p.Results.point_dist, 'unif')
        % Point projections will be uniformly placed along cluster-supporting lines
        pointproj_fun = @(len, n) len * rand(n, 1) - len / 2;
    elseif strcmp(p.Results.point_dist, 'norm')
        % Use normal distribution for placing point projections along cluster-supporting
        % lines, mean equal to line center, standard deviation equal to 1/6 of line length
        pointproj_fun = @(len, n) len * randn(n, 1) / 6;
    else
        % We should never get here
        error('Invalid program state');
    end;

    % %%%%%%%%%%%%%%%%%%%%%%%%%%%% %
    % Determine cluster properties %
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%% %

    % Normalize direction
    direction = direction / norm(direction);

    % Determine cluster sizes using the half-normal distribution (with std=1)
    clust_num_points = clusizes(...
        total_points, p.Results.allow_empty, ...
        @() abs(randn(num_clusters, 1)));

    % Determine cluster centers using the uniform distribution between -0.5 and 0.5
    centers = clucenters(...
        num_clusters, clust_sep, p.Results.cluster_offset, ...
        @() rand(num_clusters, num_dims) - 0.5);

    % Determine length of lines supporting clusters
    % Line lengths are drawn from the folded normal distribution
    lengths = abs(line_length + line_length_std * randn(num_clusters, 1));

    % Obtain angles between main direction and cluster-supporting lines
    % using the normal distribution (mean=0, std=angle_std)
    angles = angle_std * randn(num_clusters, 1);

    % Determine normalized cluster direction
    clust_dirs = zeros(num_clusters, num_dims);
    for i = 1:num_clusters
        clust_dirs(i, :) = rand_vector_at_angle(direction, angles(i));
    end;

    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
    % Determine points for each cluster %
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %

    % Aux. vector with cumulative sum of number of points in each cluster
    cumsum_points = [0; cumsum(clust_num_points)];

    % Pre-allocate data structures for holding cluster info and points
    clu_pts_idx = zeros(total_points, 1);        % Cluster indices of each point
    points_proj = zeros(total_points, num_dims); % Point projections on cluster-supporting lines
    points = zeros(total_points, num_dims);      % Final points to be generated

    % Loop through cluster and create points for each one
    for i = 1:num_clusters

        % Start and end indexes for points in current cluster
        idx_start = cumsum_points(i) + 1;
        idx_end = cumsum_points(i + 1);

        % Update cluster indices of each point
        clu_pts_idx(idx_start:idx_end) = i;

        % Determine distance of point projections from the center of the line
        ptproj_dist_center = pointproj_fun(lengths(i), clust_num_points(i));

        % Determine coordinates of point projections on the line using the
        % parametric line equation (this works since cluster direction is normalized)
        points_proj(idx_start:idx_end, :) = centers(i, :) + ptproj_dist_center * clust_dirs(i, :);

        if strcmp(p.Results.point_offset, 'd-1')

            % Get distances from points to their projections on the line
            points_dist = lateral_std * randn(clust_num_points(i), 1);

            % Get normalized vectors, orthogonal to the current line, for
            % each point
            % TODO: Vectorize this loop (but is it worth it since it needs access to global(locked?) PRNG?)
            orth_vecs = zeros(clust_num_points(i), num_dims);
            for j = 1:clust_num_points(i)
                orth_vecs(j, :) = rand_ortho_vector(clust_dirs(i, :)');
            end;

            % Set vector magnitudes
            orth_vecs = abs(points_dist) .* orth_vecs;

            % Add perpendicular vectors to point projections on the line,
            % yielding final cluster points
            pts_clu = points_proj(idx_start:idx_end, :) + orth_vecs;

        elseif strcmp(p.Results.point_offset, 'd')

            % Get random displacement vectors for each point projection
            displ = lateral_std * randn(clust_num_points(i), num_dims);

            % Add displacement vectors to each point projection
            pts_clu = points_proj(idx_start:idx_end, :) + displ;

        else
            % We should never get here
            error('Invalid program state');
        end;

        % Determine the actual points
        points(cumsum_points(i) + 1 : cumsum_points(i + 1), :) = pts_clu;

    end;

end % function

%
% Determine cluster sizes
%
% Note that dist_fun should return a n x 1 array of non-negative numbers where
% n is the desired number of clusters.
function clust_num_points = clusizes(total_points, allow_empty, dist_fun)

    % Determine number of points in each cluster
    clust_num_points = dist_fun();
    clust_num_points = clust_num_points / sum(clust_num_points);
    clust_num_points = round(clust_num_points * total_points);

    % Make sure total_points is respected
    while sum(clust_num_points) < total_points
        % If one point is missing add it to the smaller cluster
        [C, I] = min(clust_num_points);
        clust_num_points(I(1)) = C + 1;
    end;
    while sum(clust_num_points) > total_points
        % If there is one extra point, remove it from larger cluster
        [C, I] = max(clust_num_points);
        clust_num_points(I(1)) = C - 1;
    end;

    % If allow_empty is false make sure there are no empty clusters
    if ~allow_empty

        % Find empty clusters
        empty_clusts = find(clust_num_points == 0);

        % If there are empty clusters...
        if ~isempty(empty_clusts)

            % How many empty clusters do we have?
            n_empty_clusts = size(empty_clusts, 1);

            % Go through the empty clusters...
            for i = 1:n_empty_clusts
                % ...get a point from the largest cluster and assign it to the
                % current empty cluster
                [C, I] = max(clust_num_points);
                clust_num_points(I(1)) = C - 1;
                clust_num_points(empty_clusts(i)) = 1;
            end;
        end;
    end;

end %function

%
% Determine cluster centers.
%
% Note that dist_fun should return a num_clusters * num_dims matrix.
function clust_centers = clucenters(num_clusters, cluster_sep, offset, distfun)

    clust_centers = num_clusters * distfun() * diag(cluster_sep) .+ offset';

end % function

%
% Function which returns a random unit vector with `num_dims` dimensions.
%
function r = rand_unit_vector(num_dims)

    r = rand(num_dims, 1) - 0.5;
    r = r / norm(r);

end % function

%
% Function which returns a random normalized vector orthogonal to u
%
% u is expected to be a unit vector
function v = rand_ortho_vector(u)

    % Find a random, non-parallel vector to u
    while 1

        % Find normalized random vector
        r = rand_unit_vector(numel(u));

        % If not parallel to u we can keep it and break the loop
        if abs(dot(u, r)) < (1 - eps)
            break;
        end;
    end;

    % Get vector orthogonal to u using 1st iteration of Gram-Schmidt process
    v = r - dot(u, r) / dot(u, u) * u;

    % Normalize it
    v = v / norm(v);

end % function


% Function which returns a random vector that is at an angle of `angle` radians
% from vector `u`.
%
% `u` is expected to be a unit vector
% `angle` should be in radians
function v = rand_vector_at_angle(u, angle)

    if -pi/2 < angle < pi/2 && numel(u) > 1
        v = u + rand_ortho_vector(u) * tan(angle);
    else
        v = rand_unit_vector(numel(u))
    end;

    v = v / norm(v);
end