% Plot 3D examples
function f = plot_examples_3d(varargin)

    % Assume number of columns is always 3
    ncols = 3;
    % Assume side with 300px
    side = 300;

    % Get examples
    ex = varargin(1:2:end);
    % Get titles
    et = varargin(2:2:end);

    % Number of plots and number of rows in combined plot
    num_plots = floor(numel(varargin) / 2);
    nrows = max(1, ceil(num_plots / ncols));

    % Get limits in each dimension
    [xmaxs, xmins] = get_plot_lims(ex{:});

    % Determine name of file where to save plot
    filename = cell2mat(cellfun(@(s) s(1:4), et, 'UniformOutput', false));

    % Create new figure
    f = figure();

    % Generate individual subplots
    for i = 1:num_plots

        % Position current subplot
        subplot(nrows, ncols, i);

        % Draw current subplot...
        scatter3(ex{i}.points(:, 1), ex{i}.points(:, 2), ex{i}.points(:, 3), ...
            18, ex{i}.clusters, ...
            'filled', 'MarkerEdgeColor', 'black', 'LineWidth', 0.1);

        % ...and set the remaining properites
        title(et{i}, 'FontWeight', 'normal', 'FontSize', 9);
        xlim([xmins(1) xmaxs(1)]);
        ylim([xmins(2) xmaxs(2)]);
        zlim([xmins(3) xmaxs(3)]);
        xlabel('x');
        ylabel('y');
        zlabel('z');
        daspect([1 1 1]);
        grid on;

    end;

    % Define plot size and save it to a file
    set(f, 'Position', [0 0 side * ncols side * nrows]);
    set(f, 'PaperPositionMode', 'auto');
    saveas(f, [filename '.png']);

end % function

% Copyright (c) 2012-2023 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy
% at http://opensource.org/licenses/MIT)