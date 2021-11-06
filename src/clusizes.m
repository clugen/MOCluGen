
%
% Determine cluster sizes
%
% Note that dist_fn should return a n x 1 array of non-negative numbers where
% n is the desired number of clusters.
function clu_num_points = clusizes(total_points, allow_empty, dist_fn)

    % Determine number of points in each cluster
    clu_num_points = dist_fn();
    clu_num_points = clu_num_points / sum(clu_num_points);
    clu_num_points = round(clu_num_points * total_points);

    % Make sure total_points is respected
    clu_num_points = fix_num_points(clu_num_points, total_points);

    % If allow_empty is false make sure there are no empty clusters
    if ~allow_empty
        clu_num_points = fix_empty(clu_num_points, allow_empty);
    end;

end % function

% Copyright (c) 2012-2021 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy
% at http://opensource.org/licenses/MIT)