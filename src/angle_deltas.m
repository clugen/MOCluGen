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
%
% ## Note
%
% This function is stochastic. For reproducibility set the PRNG seed with
% `cluseed()` as discussed in the [API](../).
%
% ## Examples
%
%     cluseed(123);                   % Seed set to 123
%     arad = angle_deltas(4, pi / 8); % Angle dispersion of 22.5 degrees
%     rad2deg(arad')                  % Show angle deltas in degrees
%     % ans =
%     %
%     %     4.3613   21.0290  -33.2926    5.7669
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
    end;
end

% Copyright (c) 2012-2021 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy
% at http://opensource.org/licenses/MIT)