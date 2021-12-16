% Determine cluster centers using the uniform distribution, taking into account
% the number of clusters (`num_clusters`) and the average cluster separation
% (`clu_sep`).
%
%     clu_centers = clucenters(num_clusters, clu_sep, clu_offset)
%
% More specifically, let $c=$ `num_clusters`, $\mathbf{s}=$ `clu_sep`,
% $\mathbf{o}=$ `clu_offset`, $n=$ `length(clu_sep)` (i.e., number of dimensions).
% Cluster centers are obtained according to the following equation:
%
% $$
% \mathbf{C}=c\mathbf{U} \cdot \operatorname{diag}(\mathbf{s}) + \mathbf{1}\,\mathbf{o}^T
% $$
%
% where $\mathbf{C}$ is the $c \times n$ matrix of cluster centers,
% $\mathbf{U}$ is an $c \times n$ matrix of random values drawn from the
% uniform distribution between -0.5 and 0.5, and $\mathbf{1}$ is an $c \times
% 1$ vector with all entries equal to 1.
%
% ## Arguments
%
% - `num_clusters` - Number of clusters.
% - `clu_sep` - Average cluster separation (`num_clusters` x 1 vector).
% - `clu_offset` -Cluster offsets (`num_clusters` x 1 vector).
%
% ## Return values
%
% - `clu_centers` - A `num_clusters` x `num_dims` matrix containing the cluster
%   centers.
function clu_centers = clucenters(num_clusters, clu_sep, clu_offset)

    % Obtain a num_clusters x num_dims matrix of uniformly distributed values
    % between -0.5 and 0.5 representing the relative cluster centers
    ctr_rel = rand(num_clusters, numel(clu_sep)) - 0.5;

    clu_centers = num_clusters * ctr_rel * diag(clu_sep) + clu_offset';

end % function

% Copyright (c) 2012-2021 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy
% at http://opensource.org/licenses/MIT)
