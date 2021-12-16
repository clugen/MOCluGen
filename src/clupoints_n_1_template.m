% Generate points from their $n$-dimensional projections on a cluster-supporting
% line, placing each point on a hyperplane orthogonal to that line and centered
% at the point's projection. The function specified in `dist_fn` is used to
% perform the actual placement.
%
%     points = clupoints_n_1_template(projs, lat_std, clu_dir, dist_fn)
%
% This function is used internally by `clupoints_n_1()` and may be useful for
% constructing user-defined final point placement strategies for the
% `point_dist_fn` parameter of the main `clugen()` function.
%
% ## Arguments
%
% - `projs`: Point projections on the cluster-supporting line ($p \times n$
%   matrix).
% - `lat_disp`: Dispersion of points from their projection.
% - `clu_dir`: Direction of the cluster-supporting line (unit vector).
% - `dist_fn`: Function to place points on a second line, orthogonal to the
%   first.
%
% ## Return values
%
% - `points`: Generated points ($p \times n$ matrix).
%
% ## Note
%
% This function is stochastic. For reproducibility set the PRNG seed as
% discussed in the [API](..).
function points = clupoints_n_1_template(projs, lat_disp, clu_dir, dist_fn)

    % Number of dimensions
    num_dims = numel(clu_dir);

    % Number of points in this cluster
    clu_num_points = size(projs, 1);

    % Get distances from points to their projections on the line
    points_dist = dist_fn(clu_num_points, lat_disp);

    % Get normalized vectors, orthogonal to the current line, for each point
    orth_vecs = zeros(clu_num_points, num_dims);
    for j = 1:clu_num_points
        orth_vecs(j, :) = rand_ortho_vector(clu_dir);
    end;

    % Set vector magnitudes
    orth_vecs = abs(points_dist) .* orth_vecs;

    % Add perpendicular vectors to point projections on the line,
    % yielding final cluster points
    points = projs + orth_vecs;

end % function

% Copyright (c) 2012-2021 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy
% at http://opensource.org/licenses/MIT)
