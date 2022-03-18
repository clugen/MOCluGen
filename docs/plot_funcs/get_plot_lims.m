% Helper function used by all example plotting functions
function [xmaxs, xmins] = get_plot_lims(varargin)

    % Plot margins
    pmargin = 0.1;

    % Get maximum and minimum points in each dimension
    xmaxs = max(cell2mat(cellfun(@(e) max(e.points, [], 1), ...
        varargin, 'UniformOutput', false)'), [], 1);
    xmins = min(cell2mat(cellfun(@(e) min(e.points, [], 1), ...
        varargin, 'UniformOutput', false)'), [], 1);

    % Determine plots centers in each dimension
    xcenters = (xmaxs + xmins) / 2;

    % Determine plots span for all dimensions
    sidespan = (1 + pmargin) * max(abs(xmaxs - xmins)) / 2;

    % Determine final plots limits in both dimensions
    xmaxs = xcenters + sidespan;
    xmins = xcenters - sidespan;

end % function

% Copyright (c) 2012-2022 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy
% at http://opensource.org/licenses/MIT)