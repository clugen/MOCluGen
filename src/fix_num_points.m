% Certify that the values in the `clu_num_points` array, i.e. the number of
% points in each cluster, add up to `num_points`.
%
%     num_points_fixed = fix_num_points(clu_num_points, num_points)
%
% If the values in the `clu_num_points` array, i.e. the number of points in each
% cluster, don't add up to `num_points`, this function increments the number of
% points in the smallest cluster while `sum(clu_num_points) < num_points`, or
% decrements the largest cluster while `sum(clu_num_points) > num_points`.
%
% This function is used internally by [`clusizes()`](#clusizes) and might be
% useful for custom cluster sizing implementations given as the `clusizes_fn`
% parameter of the main [`clugen()`](#clugen) function.
%
% ## Arguments
%
% * `clu_num_points` - Number of points in each cluster (_c_ x 1 vector), where
%   _c_ is the number of clusters.
% * `num_points` - The expected total number of points.
%
% ## Return values
%
% * `num_points_fixed` - Number of points in each cluster, after being fixed by
%   this function.
function num_points_fixed = fix_num_points(clu_num_points, num_points)

    num_points_fixed = clu_num_points;

    % Make sure total number of points add up to num_points
    while sum(num_points_fixed) < num_points
        % If one point is missing add it to the smaller cluster
        [mn, imin] = min(num_points_fixed);
        num_points_fixed(imin) = mn + 1;
    end;
    while sum(num_points_fixed) > num_points
        % If there is one extra point, remove it from larger cluster
        [mx, imax] = max(num_points_fixed);
        num_points_fixed(imax) = mx - 1;
    end;

end % function

% Copyright (c) 2012-2021 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy
% at http://opensource.org/licenses/MIT)