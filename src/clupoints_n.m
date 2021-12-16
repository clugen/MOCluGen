
% Generate points from their ``n``-dimensional projections on a cluster-supporting
% line, placing each point around its projection using the normal distribution
% (μ=0, σ=`lat_disp`).
%
%     points = clupoints_n(projs, lat_disp, line_len, clu_dir, clu_ctr)
%
% This function's main intended use is by the `clugen()` function, generating
% the final points when the `point_dist_fn` parameter is set to `"n"`.
%
% ## Arguments
%
% - `projs`: Point projections on the cluster-supporting line.
% - `lat_disp`: Standard deviation for the normal distribution, i.e., cluster
%   lateral dispersion.
% - `line_len`: Length of cluster-supporting line (ignored).
% - `clu_dir`: Direction of the cluster-supporting line.
% - `clu_ctr`: Center position of the cluster-supporting line (ignored).
%
% # Return values
%
% - `points`: Generated points ($p \times n$ matrix).
function points = clupoints_n(projs, lat_disp, line_len, clu_dir, clu_ctr)

    % Number of dimensions
    num_dims = numel(clu_dir);

    % Number of points in this cluster
    clu_num_points = size(projs, 1);

    % Get random displacement vectors for each point projection
    displ = lat_disp * randn(clu_num_points, num_dims);

    % Add displacement vectors to each point projection
    points = projs + displ;

end % function

% Copyright (c) 2012-2021 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy
% at http://opensource.org/licenses/MIT)