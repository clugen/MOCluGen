% Determine coordinates of points on a line with `center` and `direction`, based
% on the distances from the center given in `dist_center`.
%
% This works by using the parametric line equation assuming `direction` is normalized.
function points = points_on_line(center, direction, dist_center)

    points = center' + dist_center * direction';

end % function