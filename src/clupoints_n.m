
% Function which generates points for a cluster from their projections in n-D,
% placing points using a multivariate normal distribution centered at the point
% projection.
%
% `projs` are the point projections.
% `lat_disp` is the lateral standard deviation or cluster "fatness".
% `clu_dir` is the cluster direction.
% `clu_ctr` is the cluster-supporting line center position (ignored).
function points = clupoints_n(projs, lat_disp, clu_dir, clu_ctr)

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