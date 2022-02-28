% Determine coordinates of points on a line with `center` and `direction`, based
% on the distances from the center given in `dist_center`.
%
%     points = points_on_line(center, direction, dist_center)
%
% This works by using the vector formulation of the line equation assuming
% `direction` is a $n$-dimensional unit vector. In other words, considering
% $\mathbf{d}=$ `direction` ($n \times 1$), $\mathbf{c}=$ `center`
% ($n \times 1$), and $\mathbf{w}=$ `dist_center` ($p \times 1$), the
% coordinates of points on the line are given by:
%
% $$
% \mathbf{P}=\mathbf{1}\,\mathbf{c}^T + \mathbf{w}\mathbf{d}^T
% $$
%
% where $\mathbf{P}$ is the $p \times n$ matrix of point coordinates on the
% line, and $\mathbf{1}$ is a $p \times 1$ vector with all entries equal to 1.
%
% ## Arguments
%
% * `center` - Center of the line ($n \times 1$ vector).
% * `direction` - Line direction ($n \times 1$ unit vector).
% * `dist_center` - Distance of each point to the center of the line
%   ($p \times 1$ vector, where $p$ is the number of points).
%
% ## Return values
%
% * `points` - Coordinates of points on the specified line ($p \times n$ matrix).
%
% ## Examples
%
%     points_on_line([5; 5], [1; 0], (-4:2:4)') % 2D, 5 points
%     % ans =
%     %
%     %    1   5
%     %    3   5
%     %    5   5
%     %    7   5
%     %    9   5
%
%     points_on_line([-2; 0; 0; 2], [0; 0; -1; 0], [10; -10]) % 4D, 2 points
%     % ans =
%     %
%     %    -2    0  -10    2
%     %    -2    0   10    2
function points = points_on_line(center, direction, dist_center)

    points = center' + dist_center * direction';

end % function

% Copyright (c) 2012-2021 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy
% at http://opensource.org/licenses/MIT)
