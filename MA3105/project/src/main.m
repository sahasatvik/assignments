% Define the initial value problem statements here
IVPs = [
    struct( ...
        "title",    "$y' = y - x$", ...                         % problem title
        "f",        @(x, y) y - x, ...                          % f(x, y)
        "dfdy",     @(x, y) 1, ...                              % df/dy used for Newton's method
        "y_a",      @(x) x + 1 - (1 / 3) * exp(x), ...          % y(x), analytic solution
        "x0",       0, ...                                      % x0
        "y0",       2 / 3, ...                                  % y0, initial value
        "xn",       5, ...                                      % xn, rightmost x value to compute
        "X",        0:0.2:5, ...                                % X range for direction plot
        "Y",        -10:1:10, ...                               % Y range for direction plot
        "y0s",      union(-4:1:4, 0:(1/6):2) ...                % initial values for direction plot
    ), ...
    struct( ...
        "title",    "$y' = y - x^2$", ...
        "f",        @(x, y) y - x.^2, ...
        "dfdy",     @(x, y) 1, ...
        "y_a",      @(x) x.^2 + 2*x + 2 - (4 / 3) * exp(x), ...
        "x0",       0, ...
        "y0",       2 / 3, ...
        "xn",       5, ...
        "X",        0:0.2:5, ...
        "Y",        -8:1:14, ...,
        "y0s",      union(-4:1:4, 0:(1/6):2) ...
    )
];


% Solve each IVP and display each solution in a separate figure
for ivp = IVPs   
    figure;
    sgtitle("Solving " + ivp.title, "interpreter", "latex");
    
    % 
    % Compare the trapezoidal and Euler methods with the analytic solution
    %
    
    subplot(2, 2, 1);
    
    h = 0.5;
    
    % Calculate the curves y(x)
    [y_trap, x] = ode_trap(ivp.f, ivp.dfdy, ivp.x0, ivp.xn, ivp.y0, h);
    [y_euler, ~] = ode_euler(ivp.f, ivp.x0, ivp.xn, ivp.y0, h);
    
    x_smooth = ivp.x0:1e-3:ivp.xn;
    y = ivp.y_a(x_smooth);

    plot(x_smooth, y, "-b", x, y_trap, "-rx", x, y_euler, "-gx");

    legend("Analytical", "Trapezoidal", "Euler");
    hold off
    
    title(["Comparing numerical methods" "$y(" + ivp.x0 + ") = " + ivp.y0 + "$, $h = " + h + "$"], "interpreter", "latex");
    xlabel("x");
    ylabel("y");


    %
    % Show the relative errors in the trapezoidal method, with varying h
    %

    subplot(2, 2, 3);
    
    h = 2.^(-(1:14));
    e_trap = [];
    e_euler = [];
   
    % Calculate the curves based on different step values
    hold on
    for i = 1:length(h)
        [y_trap, x] = ode_trap(ivp.f, ivp.dfdy, ivp.x0, ivp.xn, ivp.y0, h(i));
        [y_euler, ~] = ode_euler(ivp.f, ivp.x0, ivp.xn, ivp.y0, h(i));
        y = ivp.y_a(x);
        
        % Calculate the maximum errors
        e_trap(i) = max(abs(y - y_trap));
        e_euler(i) = max(abs(y - y_euler));
    end
    hold off
    
    
    loglog(h, e_trap, "-rx", h, e_euler, "-gx");
    xlabel("log(h)");
    ylabel("log(e_h)");
    legend("Trapezoidal", "Euler");
    
    title("Variation of absolute error with step size", "interpreter", "latex");
    
    % Calculate and display the slopes of the log-log error plots
    slope = @(y, x) (y(2:end) - y(1:end-1)) ./ (x(2:end) - x(1:end-1));
    
    fprintf("Comparative error between the Trapezoidal and Euler methods,\n");
    fprintf("solving %s. Here, slope refers to the slope of the\n", ivp.title);
    fprintf("log(error) vs log(h) line plot.\n\n");
    
    fprintf("%8s %12s %8s %12s %8s\n", ["h", "e_trap", "slope", "e_euler", "slope"]);
    fprintf("%8f %12f %8.4f %12f %8.4f\n", [h; ...
        e_trap; [0, slope(log(e_trap), log(h))]; ...
        e_euler; [0, slope(log(e_euler), log(h))] ...
    ]);
    disp(" ");


    %
    % Show the direction field, and plot solutions with varying initial
    % values
    %
    
    subplot(2, 2, [2 4]);

    % Calculate the direction vectors
    [X, Y] = meshgrid(ivp.X, ivp.Y);
    S = ivp.f(X, Y);                    % calculate slopes
    L = sqrt(1 + S.^2);                 % normalize lengths
    quiver(X, Y, 1./L, S./L, 0.3);      % plot arrows

    hold on
    
    h = 0.001;
    
    % Calculate curves
    for y0 = ivp.y0s
        [y_trap, x] = ode_trap(ivp.f, ivp.dfdy, ivp.X(1), ivp.X(end), y0, h);
        plot(x, y_trap, ":", "LineWidth", 2)
    end
    
    axis([ivp.X(1), ivp.X(end), ivp.Y(1), ivp.Y(end)])
    hold off
    title("Direction field", "interpreter", "latex");
    xlabel("x");
    ylabel("y");
    
end