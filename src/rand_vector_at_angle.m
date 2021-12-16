% Get a random unit vector which is at `angle` radians of vector `u`.
%
%     v = rand_vector_at_angle(u, angle)
%
% ## Arguments
%
% * `u` - A unit vector.
% * `angle` - An angle in radians.
%
% ## Return values
%
% * `v` - A random unit vector which is at `angle` radians with vector `u`
%
% ## Note
%
% This function is stochastic. For reproducibility set the PRNG seed as
% discussed in the [API](..).
function v = rand_vector_at_angle(u, angle)

    if abs(abs(angle) - pi/2) < eps && numel(u) > 1
        v = rand_ortho_vector(u);
    elseif -pi/2 < angle < pi/2 && numel(u) > 1
        v = u + rand_ortho_vector(u) * tan(angle);
        v = v / norm(v);
    else
        % For |θ| > π/2 or the 1D case, simply return a random vector
        v = rand_unit_vector(numel(u));
    end;

end % function

% Copyright (c) 2012-2021 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy
% at http://opensource.org/licenses/MIT)
