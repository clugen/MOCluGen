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

% Copyright (c) 2012-2021 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy
% at http://opensource.org/licenses/MIT)
