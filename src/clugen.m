% Generate multidimensional clusters.
%
%     [points, point_clusters, point_projections, cluster_sizes, ...
%         cluster_centers, cluster_directions, cluster_angles, cluster_lengths] = ...
%         clugen( ...
%             num_dims, ...
%             num_clusters, ...
%             num_points, ...
%             direction, ...
%             angle_disp, ...
%             cluster_sep, ...
%             llength, ...
%             llength_disp, ...
%             lateral_disp, ...
%             varargin)
%
% This is the main function of the MOCluGen package, and possibly the only
% function most users will need.
%
% ## Arguments (mandatory)
%
% - `num_dims`: Number of dimensions.
% - `num_clusters`: Number of clusters to generate.
% - `num_points`: Total number of points to generate.
% - `direction`: Average direction of the cluster-supporting lines (`num_dims` x 1).
% - `angle_disp`: Angle dispersion of cluster-supporting lines (radians).
% - `cluster_sep`: Average cluster separation in each dimension (`num_dims` x 1).
% - `llength`: Average length of cluster-supporting lines.
% - `llength_disp`: Length dispersion of cluster-supporting lines.
% - `lateral_disp`: Cluster lateral dispersion, i.e., dispersion of points from their
%   projection on the cluster-supporting line.
%
% Note that the terms "average" and "dispersion" refer to measures of central tendency
% and statistical dispersion, respectively. Their exact meaning depends on the optional
% arguments, described next.
%
% ## Arguments (optional)
%
% - `allow_empty`: Allow empty clusters? `false` by default.
% - `cluster_offset`: Offset to add to all cluster centers. By default the offset
%   will be equal to `zeros(num_dims)`.
% - `proj_dist_fn`: Distribution of point projections along cluster-supporting lines,
%   with three possible values:
%   - `"norm"` (default): Distribute point projections along lines using a normal
%     distribution (μ=_line center_, σ=`llength/6`).
%   - `"unif"`: Distribute points uniformly along the line.
%   - User-defined function, which accepts two parameters, line length (float) and
%     number of points (integer), and returns an array containing the distance of
%     each point projection to the center of the line. For example, the `"norm"`
%     option roughly corresponds to `@(len, n) len * randn(n, 1) / 6`.
% - `point_dist_fn`: Controls how the final points are created from their projections
%   on the cluster-supporting lines, with three possible values:
%   - `"n-1"` (default): Final points are placed on a hyperplane orthogonal to
%     the cluster-supporting line, centered at each point's projection, using the
%     normal distribution (μ=0, σ=`lateral_disp`). This is done by the
%     `clupoints_n_1()` function.
%   - `"n"`: Final points are placed around their projection on the cluster-supporting
%     line using the normal distribution (μ=0, σ=`lateral_disp`). This is done by the
%     `clupoints_n()` function.
%   - User-defined function: The user can specify a custom point placement strategy
%     by passing a function with the same signature as `clupoints_n_1()`and
%     `clupoints_n().
% - `clusizes_fn`: Distribution of cluster sizes. By default, cluster sizes are
%   determined by the `clusizes()` function, which uses the normaldistribution
%   (μ=`num_points`/`num_clusters`, σ=μ/3), and assures that the finalcluster
%   sizes add up to `num_points`. This parameter allows the user to specify a
%   custom function for this purpose, which must follow `clusizes()`signature.
%   Note that custom functions are not required to strictly obey the `num_points`
%   parameter.
% - `clucenters_fn`: Distribution of cluster centers. By default, cluster centers
%   are determined by the `clucenters()` function, which uses the uniform
%   distribution, and takes into account the `num_clusters` and `cluster_sep`
%   parameters for generating well-distributed cluster centers. This parameter allows
%   the user to specify a custom function for this purpose, which must follow
%   `clucenters()` signature.
% - `llengths_fn`: Distribution of line lengths. By default, the lengths of
%   cluster-supporting lines are determined by the `llengths()` function, which
%   uses the folded normal distribution (μ=`llength`, σ=`llength_disp`). This
%   parameter allows the user to specify a custom function for this purpose, which
%   must follow `llengths()` signature.
% - `angle_deltas_fn`: Distribution of line angle differences with respect to `direction`.
%   By default, the angles between `direction` and the direction of cluster-supporting
%   lines are determined by the `angle_deltas()` function, which uses the wrapped
%   normal distribution (μ=0, σ=`angle_disp`) with support in the interval
%   [-π/2, π/2]. This parameter allows the user to specify a custom function for this
%   purpose, which must follow `angle_deltas()` signature.
%
% ## Return values
%
% - `points`: A `num_points` x `num_dims` matrix with the generated points for
%    all clusters.
% - `point_clusters`: A `num_points` x 1 vector indicating which cluster
%   each point in `points` belongs to.
% - `point_projections`: A `num_points` x `num_dims` matrix with the point
%   projections on the cluster-supporting lines.
% - `cluster_sizes`: A `num_clusters` x 1 vector with the number of
%   points in each cluster.
% - `cluster_centers`: A `num_clusters` x `num_dims` matrix with the coordinates
%   of the cluster centers.
% - `cluster_directions`: A `num_clusters` x `num_dims` matrix with the direction
%   of each cluster-supporting line.
% - `cluster_angles`: A `num_clusters` x 1 vector with the angles between the
%   cluster-supporting lines and the main direction.
% - `cluster_lengths`: A `num_clusters` x 1 vector with the lengths of the
%   cluster-supporting lines.
%
% Note that if a custom function was given in the `clusizes_fn` parameter, it is
% possible that `num_points` may have a different value than what was specified in
% `clugen`'s `num_points` parameter.
%
% ## Examples
%
%     [points, point_clusters] = clugen(3, 4, 1000, [1; 0; 0], 0.1, [20; 15; 35], 12, 4, 0.5, 'allow_empty', true);
%
% This creates 4 clusters in 3D space with a total of 1000 points, with a main
% direction of [1; 0; 0] (i.e., along the x-axis), with an angle dispersion of
% 0.1, average cluster separation of [20; 15; 35], average length of
% cluster-supporting lines of 12 (dispersion of 4 units), and lateral_disp of
% 0.5. The `allow_empty` parameter is set to `true`, demonstrating how to use
% the optional arguments.
%
% The following command plots the generated clusters:
%
%     scatter3(points(:, 1), points(:, 2), points(:,3), 8, point_clusters);
%
% ## Note
%
% This function is stochastic. For reproducibility set the PRNG seed as
% discussed in the [API](..).
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

    % %%%%%%%%%%%%%%% %
    % Validate inputs %
    % %%%%%%%%%%%%%%% %

    % Known distributions for sampling points along lines
    proj_dist_fns = {'norm', 'unif'};
    point_dist_fns = {'n-1', 'n'};

    % Setup input validation
    p = inputParser;

    % Check that number of dimensions is > 0
    addRequired(p, 'num_dims', ...
        @(x) isnumeric(x) && isscalar(x) && (x > 0) && (mod(x, 1) == 0));

    % Check that number of clusters is > 0
    addRequired(p, 'num_clusters', ...
        @(x) isnumeric(x) && isscalar(x) && (x > 0) && (mod(x, 1) == 0));

    % Check that num_points is zero or more
    addRequired(p, 'num_points', ...
        @(x) isnumeric(x) && isscalar(x) && (x >= 0) && (mod(x, 1) == 0));

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

    % Check that allow_empty is a boolean
    addParameter(p, 'allow_empty', false, ...
        @(x) isscalar(x) && isa(x, 'logical'));

    % If given, cluster_offset must have the correct number of dimensions,
    % if not given then it will be a num_dims x 1 vector of zeros
    addParameter(p, 'cluster_offset', zeros(num_dims, 1), ...
        @(x) isnumeric(x) && all(size(x) == [num_dims 1]));

    % Check that proj_dist_fn specifies a valid way for projecting points along
    % cluster-supporting lines, i.e., either 'norm' (default), 'unif' or a
    % user-defined function
    addParameter(p, 'proj_dist_fn', proj_dist_fns{1}, ...
        @(x) isa(x, 'function_handle') || any(validatestring(x, proj_dist_fns)));

    % Check that point_dist_fn specifies a valid way for generating points given
    % their projections along cluster-supporting lines, i.e., either 'n-1'
    % (default), 'n' or a user-defined function
    addParameter(p, 'point_dist_fn', point_dist_fns{1}, ...
        @(x) isa(x, 'function_handle') || any(validatestring(x, point_dist_fns)));

    % Check that clusizes_fn is a function, and if it was not given, assign the
    % clusizes() function as the default
    addParameter(p, 'clusizes_fn', @clusizes, @(x) isa(x, 'function_handle'));

    % Check that clucenters_fn is a function, and if it was not given, assign
    % the clucenters() function as the default
    addParameter(p, 'clucenters_fn', @clucenters, @(x) isa(x, 'function_handle'));

    % Check that llengths_fn is a function, and if it was not given, assign the
    % llengths() function as the default
    addParameter(p, 'llengths_fn', @llengths, @(x) isa(x, 'function_handle'));

    % Check that angle_deltas_fn is a function, and if it was not given, assign
    % the angle_deltas() function as the default
    addParameter(p, 'angle_deltas_fn', @angle_deltas, @(x) isa(x, 'function_handle'));

    % Perform input validation and parsing
    parse(p, num_dims, num_clusters, num_points, direction, angle_disp, ...
        cluster_sep, llength, llength_disp, lateral_disp, varargin{:});

    % If allow_empty is false, make sure there are enough points to distribute
    % by the clusters
    if ~p.Results.allow_empty && num_points < num_clusters
        error(['A total of ' int2str(num_points) 'is not enough for '...
            int2str(num_clusters) ' non-empty clusters']);
    end;

    % What distribution to use for point projections along cluster-supporting lines?
    if isa(p.Results.proj_dist_fn, 'function_handle')
        % Use user-defined distribution; assume function accepts length of line
        % and number of points, and returns a number of points x 1 vector
        pointproj_fn = p.Results.proj_dist_fn;
    elseif strcmp(p.Results.proj_dist_fn, 'unif')
        % Point projections will be uniformly placed along cluster-supporting lines
        pointproj_fn = @(len, n) len * rand(n, 1) - len / 2;
    elseif strcmp(p.Results.proj_dist_fn, 'norm')
        % Use normal distribution for placing point projections along cluster-supporting
        % lines, mean equal to line center, standard deviation equal to 1/6 of line length
        % such that the line length contains ≈99.73% of the points
        pointproj_fn = @(len, n) len * randn(n, 1) / 6;
    else
        % We should never get here
        error('Invalid program state');
    end;

    % What distribution to use for placing points from their projections?
    if num_dims == 1
        % If 1D was specified, point projections are the points themselves
        pt_from_proj_fn = @(projs, lat_disp, len, clu_dir, clu_ctr) projs;
    elseif isa(p.Results.point_dist_fn, 'function_handle')
        % Use user-defined distribution; assume function accepts point projections
        % on the line, lateral disp., cluster direction and cluster center, and
        % returns a num_points x num_dims matrix containing the final points
        % for the current cluster
        pt_from_proj_fn = p.Results.point_dist_fn;
    elseif strcmp(p.Results.point_dist_fn, 'n-1')
        % Points will be placed on a hyperplane orthogonal to the cluster-supporting
        % line using a normal distribution centered at their intersection
        pt_from_proj_fn = @clupoints_n_1;
    elseif strcmp(p.Results.point_dist_fn, 'n')
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
    cluster_sizes = p.Results.clusizes_fn(num_clusters, num_points, p.Results.allow_empty);

    % Custom clusizes_fn's are not required to obey num_points, so we update
    % it here just in case it's different from what the user specified
    num_points = sum(cluster_sizes);

    % Determine cluster centers
    cluster_centers = p.Results.clucenters_fn(num_clusters, cluster_sep, p.Results.cluster_offset);

    % Determine length of lines supporting clusters
    cluster_lengths = p.Results.llengths_fn(num_clusters, llength, llength_disp);

    % Obtain angles between main direction and cluster-supporting lines
    cluster_angles = p.Results.angle_deltas_fn(num_clusters, angle_disp);

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
    point_clusters = zeros(num_points, 1);           % Cluster indices of each point
    point_projections = zeros(num_points, num_dims); % Point projections on cluster-supporting lines
    points = zeros(num_points, num_dims);            % Final points to be generated

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
            point_projections(idx_start:idx_end, :), ...
            lateral_disp, ...
            cluster_lengths(i), ...
            cluster_directions(i, :)', ...
            cluster_centers(i, :)');

    end;

end % function

% Copyright (c) 2012-2021 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy
% at http://opensource.org/licenses/MIT)
