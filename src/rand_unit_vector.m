% Get a random unit vector with `num_dims` dimensions.
%
%     r = rand_unit_vector(num_dims)
%
% ## Arguments
%
% * `num_dims` - Number of dimensions.
%
% ## Return values
%
% * `r` - A random unit vector with `num_dims` dimensions.
%
% ## Note
%
% This function is stochastic. For reproducibility set the PRNG seed with
% `cluseed()` as discussed in the [Reference](../).
%
% ## Examples
%
%     r = rand_unit_vector(4);
%     norm(r)
%     % ans = 1
function r = rand_unit_vector(num_dims)

    r = rand(num_dims, 1) - 0.5;
    r = r / norm(r);

end % function

% Copyright (c) 2012-2023 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy
% at http://opensource.org/licenses/MIT)
