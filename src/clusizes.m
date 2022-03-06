
% Determine cluster sizes, i.e., the number of points in each cluster, using the
% normal distribution (μ=`num_points`/`num_clusters`, σ=μ/3), and then assuring
% that the final cluster sizes add up to `num_points` via the
% `fix_num_points()` function.
%
%      clu_num_points = clusizes(num_clusters, num_points, allow_empty)
%
% ## Arguments
%
% - `num_clusters`: Number of clusters.
% - `num_points`: Total number of points.
% - `allow_empty`: Allow empty clusters?
%
% ## Return values
%
% - `clu_num_points`: Number of points in each cluster (`num_clusters` x 1 vector).
%
% ## Note
%
% This function is stochastic. For reproducibility set the PRNG seed with
% `cluseed()` as discussed in the [API](../).
%
% ## Examples
%
%     cluseed(123);
%     sizes = clusizes(4, 1000, true)
%     % sizes =
%     %    268
%     %    330
%     %    128
%     %    274
%     sum(sizes)
%     % ans = 1000
function clu_num_points = clusizes(num_clusters, num_points, allow_empty)

    % Determine number of points in each cluster using the normal distribution

    % Consider the mean an equal division of points between clusters
    cmean = num_points / num_clusters;

    % The standard deviation is such that the interval [0, 2 * mean] will contain
    % ≈99.7% of cluster sizes
    std = cmean / 3;

    % Determine points with the normal distribution
    clu_num_points = std * randn(num_clusters, 1) + cmean;

    % Set negative values to zero
    clu_num_points = max(clu_num_points, 0);

    % Fix imbalances, so that num_points is respected
    if sum(clu_num_points) > 0 % Be careful not to divide by zero
        clu_num_points = (num_points / sum(clu_num_points)) * clu_num_points;
    end

    % Round the real values to integers since a cluster sizes is represented by
    % an integer
    clu_num_points = round(clu_num_points);

    % Make sure num_points is respected
    clu_num_points = fix_num_points(clu_num_points, num_points);

    % If allow_empty is false make sure there are no empty clusters
    if ~allow_empty
        clu_num_points = fix_empty(clu_num_points, allow_empty);
    end;

end % function

% Copyright (c) 2012-2021 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy
% at http://opensource.org/licenses/MIT)