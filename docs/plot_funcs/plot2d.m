% Plot 2D examples
function f = plot2d(tag, full_title, varargin)

    num_plots = floor(numel(varargin) / 2);

    ncols = 3;
    nrows = max(1, floor(num_plots / ncols));

    pmargin = 0.1;

    xmax = -Inf;
    xmin = Inf;
    ymax = -Inf;
    ymin = Inf;

    for i = 1:num_plots

        points = varargin{i * 2 - 1};

        if max(points(:, 1)) > xmax
            xmax = max(points(:, 1));
        end;
        if min(points(:, 1)) < xmin
            xmin = min(points(:, 1));
        end;
        if max(points(:, 2)) > ymax
            ymax = max(points(:, 2));
        end;
        if min(points(:, 2)) < ymin
            ymin = min(points(:, 2));
        end;

    end;

    xd = pmargin * abs(xmax - xmin);
    yd = pmargin * abs(ymax - ymin);

    xmax = xmax + xd;
    xmin = xmin - xd;
    ymax = ymax + yd;
    ymin = ymin - yd;

    f = figure();

    for i = 1:num_plots

        subplot(nrows, ncols, i);
        points = varargin{i * 2 - 1};
        clusts = varargin{i * 2};

        scatter(points(:, 1), points(:, 2), 28, clusts, ...
            'filled', 'MarkerEdgeColor', 'black');
        title([tag ': ' full_title], 'FontWeight', 'normal', 'FontSize', 9);
        xlim([xmin xmax]);
        ylim([ymin ymax]);
        daspect([1 1 1]);
        grid on;
    end;

    set(f, 'Position', [100 100 1000 400]);
    set(f, 'PaperPositionMode', 'auto');
    saveas(f, [tag '.svg']);

end % function

% Copyright (c) 2012-2022 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy
% at http://opensource.org/licenses/MIT)