% Usage example: pretty_plot(0.4:0.01:7, @f3, x)

function pretty_plot(x, f, points)
    
    % Plot the function
    plot(x, f(x), '-k', 'LineWidth', 2)
    hold on
    plot(x, x, '-b', 'LineWidth', 2)
    
    % Plot the iteration path
    x_ = reshape([points, points]', [], 1);
    y_ = [x_(2:end); f(points(end))];
    plot(x_, y_, '-r', 'LineWidth', 1)
    
    % Limit the axes
    xlim([x(1), x(end)]);
    ylim([x(1), x(end)]);
    
    % Arrows
    quiver(points, points, points*0, (f(points) - points), '-r')
    quiver(points, f(points), (f(points) - points), points*0, '-r')
    
    hold off
end