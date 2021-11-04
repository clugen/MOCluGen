% Copyright (c) 2012-2021 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy
% at http://opensource.org/licenses/MIT)

function points = points_on_line(center, direction, dist_center)
% POINTS_ON_LINE Determine coordinates of points on a line with `center` and
% `direction`, based on the distances from the center given in `dist_center`.
%
% points = POINTS_ON_LINE(center, direction, dist_center)
%
% This works by using the vector formulation of the line equation assuming
% `direction` is a n-dimensional unit vector.
%
% ## Arguments
%
% * `center` - Center of the line (n x 1 vector).
% * `direction` - Line direction (n x 1 unit vector).
% * `dist_center` - Distance of each point to the center of the line (p x 1
%   vector, where p is the number of points).

    points = center' + dist_center * direction';

end % function