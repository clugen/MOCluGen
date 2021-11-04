% Copyright (c) 2012-2021 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy
% at http://opensource.org/licenses/MIT)

function r = rand_unit_vector(num_dims)
% RAND_UNIT_VECTOR Get a random unit vector with `num_dims` dimensions.
%
% r = RAND_UNIT_VECTOR(num_dims)
%
% ## Arguments
%
% * `num_dims` - Number of dimensions.
%
% ## Return values
%
% * `r` - A random unit vector with `num_dims` dimensions.
%
    r = rand(num_dims, 1) - 0.5;
    r = r / norm(r);

end % function
