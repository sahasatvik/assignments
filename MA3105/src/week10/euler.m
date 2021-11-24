function [y, x] = euler(f, x0, y0, h, xn)
    y(1) = y0;
    x = x0:h:xn;
    n = length(x);
    for i = 2:n
        y(i) = y(i - 1) + h * f(x(i - 1), y(i - 1));
    end
end