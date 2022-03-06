% Generate points from their _n_-dimensional projections on a cluster-supporting
% line, placing each point on a hyperplane orthogonal to that line and centered
% at the point's projection, using the normal distribution (μ=0, σ=`lat_disp`).
%
%     points = clupoints_n_1(projs, lat_disp, line_len, clu_dir, clu_ctr)
%
% This function's main intended use is by the `clugen()` function, generating
% the final points when the `point_dist_fn` parameter is set to `"n-1"`.
%
% ## Arguments
%
% - `projs`: Point projections on the cluster-supporting line ($p \times n$
%   matrix).
% - `lat_disp`: Standard deviation for the normal distribution, i.e., cluster
%   lateral dispersion.
% - `line_len`: Length of cluster-supporting line (ignored).
% - `clu_dir`: Direction of the cluster-supporting line (unit vector).
% - `clu_ctr`: Center position of the cluster-supporting line (ignored).
%
% ## Return values
%
% - `points`: Generated points ($p \times n$ matrix).
%
% ## Note
%
% This function is stochastic. For reproducibility set the PRNG seed with
% `cluseed()` as discussed in the [API](../).
%
% ## Examples
%
%     cluseed(123);
%     ctr = [0; 0];
%     direc = [1; 0];
%     pdist = [-0.5; -0.2; 0.1; 0.3];
%     proj = points_on_line(ctr, direc, pdist);
%     clupoints_n_1(proj, 0.1, nan, direc, nan)
%     % ans =
%     %
%     %   -0.500000  -0.019383
%     %   -0.200000  -0.093462
%     %    0.100000  -0.147967
%     %    0.300000  -0.025630
function points = clupoints_n_1(projs, lat_disp, line_len, clu_dir, clu_ctr)

    % Define function to get distances from points to their projections on the
    % line (i.e., using the normal distribution)
    dist_fn = @(clu_num_points, ldisp) ldisp * randn(clu_num_points, 1);

    % Use clupoints_n_1_template() to do the heavy lifting
    points = clupoints_n_1_template(projs, lat_disp, clu_dir, dist_fn);

end % function

% Copyright (c) 2012-2021 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy
% at http://opensource.org/licenses/MIT)