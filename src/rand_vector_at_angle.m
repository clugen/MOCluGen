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
% This function is stochastic. For reproducibility set the PRNG seed with
% `cluseed()` as discussed in the [Reference](../).
%
% ## Examples
%
%     u = [1.0; 0; 0.5; -0.5];             % Define a 4D vector
%     u = u / norm(u);                     % Normalize the vector
%     v = rand_vector_at_angle(u, pi / 4); % Get a vector at 45 degrees
%     arad = acos(dot(u, v) / (norm(u) * norm(v))); % Get angle in radians
%     rad2deg(arad) % Convert to degrees, should be close to 45 degrees
%     % ans = 45.000
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

% Copyright (c) 2012-2023 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy
% at http://opensource.org/licenses/MIT)
