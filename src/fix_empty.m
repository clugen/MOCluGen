% Certify that, given enough points, no clusters are left empty.
%
%     num_points_fixed = fix_empty(clu_num_points, allow_empty)
%
% This is done by removing a point from the largest cluster and adding it to an
% empty cluster while there are empty clusters. If the total number of points is
% smaller than the number of clusters (or if the `allow_empty` parameter is set
% to `true`), this function does nothing.
%
% This function is used internally by [`clusizes()`](#clusizes) and might be
% useful for custom cluster sizing implementations given as the `clusizes_fn`
% parameter of the main [`clugen()`](#clugen) function.
%
% ## Arguments
%
% * `clu_num_points` - Number of points in each cluster (_c_ x 1 vector), where
%   _c_ is the number of clusters.
% * `allow_empty` - Allow empty clusters?
%
% ## Return values
%
% * `num_points_fixed` - Number of points in each cluster, after being fixed by
%   this function.
function num_points_fixed = fix_empty(clu_num_points, allow_empty)

    num_points_fixed = clu_num_points;

    % If the allow_empty parameter is set to true, don't change the number of
    % points in each cluster; this is useful for quick `clusizes_fn` one-liners
    if ~allow_empty

        % Find empty clusters
        empty_clusts = find(num_points_fixed == 0);

        % If there are empty clusters and enough points for all clusters...
        if numel(empty_clusts) > 0 && sum(num_points_fixed) >= numel(num_points_fixed)

            % Go through the empty clusters...
            for i0 = empty_clusts'

                % ...get a point from the largest cluster and assign it to the
                % current empty cluster
                [mx, imax] = max(num_points_fixed);
                num_points_fixed(imax) = mx - 1;
                num_points_fixed(i0) = 1;

            end;
        end;
    end;

end % function

% Copyright (c) 2012-2021 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy
% at http://opensource.org/licenses/MIT)