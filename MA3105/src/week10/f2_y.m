function y = f2_y(x)
    y = x.^2 + 2*x + 2 - 2*(x + 1).*log(x + 1);
end