function [y, x] = ode_euler(f, x0, xn, y0, h)
    x = x0:h:xn;
    n = length(x);
    y(1) = y0;
    
    for i = 1:n-1
        y(i + 1) = y(i) + h * f(x(i), y(i));
    end
end