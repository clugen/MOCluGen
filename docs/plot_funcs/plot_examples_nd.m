% Plot nD examples
function f = plot_examples_nd(e, plt_title)

    % How many dimensions
    nd = size(e.points, 2);

    % Assume side with 200px
    side = 200;

    % Get limits in each dimension
    [xmaxs, xmins] = get_plot_lims(e);

    % Determine name of file where to save plot
    filename = plt_title(1:3);

    % Create new figure and set main title
    f = figure();

    % Generate individual subplots
    for i = 1:nd
        for j = 1:nd

            % Position current subplot
            subplot(nd, nd, (i - 1) * nd + j);%, 'parent', p);

            if (i == j)
                % No axis...
                axis('off');
                % ...just put x1, etc in the middle of plot
                text(0.5, 0.5, ['x_' num2str(i)], 'FontSize', 14, ...
                    'HorizontalAlignment', 'center');

            else

                % Draw current subplot...
                scatter(e.points(:, i), e.points(:, j), 12, e.clusters);

                % ...and set the remaining properites
                xlim([xmins(i) xmaxs(i)]);
                ylim([xmins(j) xmaxs(j)]);
                daspect([1 1 1]);
                grid on;
            end;

        end;
    end;

    % Set plot title
    a = axes();
    t = title(plt_title);
    set(a, 'visible', 'off');
    set(t, 'visible', 'on');

    % Define plot size and save it to a file
    set(f, 'Position', [0 0 side * nd side * nd]);
    set(f, 'PaperPositionMode', 'auto');
    saveas(f, [filename '.png']);

end % function

% Copyright (c) 2012-2022 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy
% at http://opensource.org/licenses/MIT)