
% Function which generates points for a cluster from their projections in n-D,
% placing points on a second line perpendicular to the cluster-supporting line
% using a normal distribution centered at their intersection.
%
% `projs` are the point projections.
% `lat_disp` is the lateral standard deviation or cluster "fatness".
% `clu_dir` is the cluster direction.
% `clu_ctr` is the cluster-supporting line center position (ignored).
function points = clupoints_n_1(projs, lat_disp, clu_dir, clu_ctr)

    % Define function to get distances from points to their projections on the
    % line (i.e., using the normal distribution)
    dist_fn = @(clu_num_points, ldisp) ldisp * randn(clu_num_points, 1);

    % Use clupoints_n_1_template() to do the heavy lifting
    points = clupoints_n_1_template(projs, lat_disp, clu_dir, dist_fn);

end % function

% Copyright (c) 2012-2021 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy
% at http://opensource.org/licenses/MIT)