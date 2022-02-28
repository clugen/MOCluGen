
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
% ## Return values
%
% - `points`: Generated points ($p \times n$ matrix).
%
% ## Note
%
% This function is stochastic. For reproducibility set the PRNG seed as
% discussed in the [API](..).
%
% ## Examples
%
%     % Seed set to 123 in Octave for this example
%     ctr = [0; 0];
%     direc = [1; 0];
%     pdist = [-0.5; -0.2; 0.1; 0.3];
%     proj = points_on_line(ctr, direc, pdist);
%     clupoints_n(proj, 0.01, nan, direc, nan)
%     % ans =
%     %   -0.4980617   0.0061540
%     %   -0.1906538  -0.0020521
%     %    0.0852033   0.0163463
%     %    0.3025630  -0.0110016
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