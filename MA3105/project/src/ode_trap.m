function [y, x] = ode_trap(f, dfdy, x0, xn, y0, h)
    % Set up the points on which to iterate
    x = x0:h:xn;
    n = length(x);
    y(1) = y0;
    
    for i = 1:n-1
        % Set up functions for solving the implicit equation
        F = @(t) y(i) - t + (h / 2) * (f(x(i), y(i)) + f(x(i + 1), t));
        dFdt = @(t) -1 + (h / 2) * dfdy(x(i + 1), t);
        
        % Use one Euler's method to get an initial guess
        y(i + 1) = y(i) + h * f(x(i), y(i));
        
        % Use Newton's method to solve the implicit equation
        y(i + 1) = root_newton(F, dFdt, y(i + 1), eps, 10);
    end
end
