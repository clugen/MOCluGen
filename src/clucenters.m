%
% Determine cluster centers.
%
% Note that dist_fn should return a num_clusters * num_dims matrix.
function clu_centers = clucenters(num_clusters, clu_sep, clu_offset, dist_fn)

    clu_centers = num_clusters * dist_fn() * diag(clu_sep) + clu_offset';

end % function

% Copyright (c) 2012-2021 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy
% at http://opensource.org/licenses/MIT)