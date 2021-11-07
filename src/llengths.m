% Determine length of cluster-supporting lines using the folded normal
% distribution (μ=`llength`, σ=`llength_disp`).
%
%     lengths = llengths(num_clusters, llength, llength_disp)
%
% ## Arguments
%
% - `num_clusters`: Number of clusters.
% - `llength`: Average line length.
% - `llength_disp`: Line length dispersion.
%
% ## Return values
%
% - `lengths`: Lengths of cluster-supporting lines (`num_clusters` x 1 vector).
function lengths = llengths(num_clusters, llength, llength_disp)

    lengths = abs(llength + llength_disp * randn(num_clusters, 1));

end

% Copyright (c) 2012-2021 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy
% at http://opensource.org/licenses/MIT)