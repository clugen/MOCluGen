% Get a random unit vector orthogonal to `u`.
%
%     v = rand_ortho_vector(u)
%
% ## Arguments
%
% * `u` - A unit vector.
%
% ## Return values
%
% * `v` - A random unit vector orthogonal to `u`.
%
% ## Note
%
% This function is stochastic. For reproducibility set the PRNG seed with
% `cluseed()` as discussed in the [Reference](../).
%
% ## Examples
%
%     r = rand(3, 1);           % Get a random 3D vector
%     r = r / norm(r);          % Normalize it
%     o = rand_ortho_vector(r); % Get a random unit vector orthogonal to r
%     dot(r, o)    % Check that r and o are orthogonal (result should be ~0)
%     % ans = 0
function v = rand_ortho_vector(u)

    % Is vector 1D?
    if numel(u) == 1
        % If so, just return a random unit vector

        v = rand_unit_vector(1);

    else
        % Otherwise proceed normally

        % Find a random, non-parallel vector to u
        while 1

            % Find normalized random vector
            r = rand_unit_vector(numel(u));

            % If not parallel to u we can keep it and break the loop
            if abs(dot(u, r)) < (1 - eps)
                break;
            end;
        end;

        % Get vector orthogonal to u using 1st iteration of Gram-Schmidt process
        v = r - dot(u, r) / dot(u, u) * u;

        % Normalize it
        v = v / norm(v);

    end; % if-else

end % function

% Copyright (c) 2012-2023 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy
% at http://opensource.org/licenses/MIT)
