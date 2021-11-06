% Determine the angles between the average cluster direction and the
% cluster-supporting lines using the wrapped normal distribution
% (μ=0, σ=`angle_disp`) with support in the interval [-π/2, π/2].
%
%     angd = angle_deltas(num_clusters, angle_disp)
%
% ## Arguments
%
% - `num_clusters` - Number of clusters.
% - `angle_disp` - Angle dispersion, in radians.
%
% ## Return values
%
% - `angles` - Angles between the average cluster direction and the
%   cluster-supporting lines, given in radians in the interval [-π/2, π/2].
function angles = angle_deltas(num_clusters, angle_disp)

    % Get random angle differences using the normal distribution
    angles = angle_disp * randn(num_clusters, 1);

    % Make sure angle differences are within interval [-π/2, π/2]
    angles = arrayfun(@minangle, angles);

end

% Helper function to return the minimum valid angle
function ma = minangle(a)
    ma = atan2(sin(a), cos(a));
    if ma > pi/2
        ma = ma - pi;
    elseif ma < -pi/2
        ma = ma + pi;
    end
end

% Copyright (c) 2012-2021 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy
% at http://opensource.org/licenses/MIT)