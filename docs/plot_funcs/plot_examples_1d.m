% Plot 1D examples
function f = plot_examples_1d(varargin)

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

    % Maximum density (for adjusting plot later)
    max_density = -Inf;

    % Get current colormap
    cmap = colormap();

    % Generate individual subplots
    for i = 1:num_plots

        % Position current subplot
        subplot(nrows, ncols, i);
        hold on;

        % Get unique clusters
        clusters = unique(ex{i}.clusters);

        % Number of clusters
        nclu = numel(clusters);

        % Determine colormap indexes
        cmidxs = round(linspace(1, size(cmap, 1), nclu));

        % Plot each cluster
        for j = 1:nclu

            % Get density estimation for current cluster
            [~, density, xmesh] = kde(ex{i}.points(ex{i}.clusters == j));

            % Is current maximum density the maximum?
            max_density = max(max_density, max(density));

            % Determine color for current cluster
            cclr = cmap(cmidxs(j), :);

            % Area under plot
            area(xmesh, density, 'FaceColor', cclr, 'FaceAlpha', 0.3);

            % Plot
            plot(xmesh, density, 'Color', cclr, 'LineWidth', 1.2);

        end;

        % Plot points
        scatter(ex{i}.points, -0.01 * ones(numel(ex{i}.points), 1), 8, ex{i}.clusters);%, ...
            %'filled', 'MarkerEdgeColor', 'black');

        % ...and set the remaining properites
        title(et{i}, 'FontWeight', 'normal', 'FontSize', 9);
        xlim([xmins(1) xmaxs(1)]);
        %ylim([xmins(2) xmaxs(2)]);
        %daspect([1 1 1]);
        grid on;
        hold off;

    end;


    % Set final plot vertical sizes
    for i = 1:num_plots

        % Position current subplot
        subplot(nrows, ncols, i);

        % Set vertical size
        ylim([-0.03 max_density * 1.03]);

    end;

    % Define plot size and save it to a file
    set(f, 'Position', [0 0 side * ncols side * nrows]);
    set(f, 'PaperPositionMode', 'auto');
    saveas(f, [filename '.png']);

end % function

% Copyright (c) 2012-2023 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy
% at http://opensource.org/licenses/MIT)