x = 1:5;

disp("Function (a)");
for h = [0.2, 0.1, 0.05]
    [y_, x_] = euler(@f1, 0, 1, h, x(end));
    y = y_(ismember(x_, x));
    err = f1_y(x) - y;
    rel_err = err ./ f1_y(x);
    fprintf("h = %.2f\n", h);
    fprintf("%8s %12s %12s %12s\n", "x", "y_h(x)", "Error", "Rel. Err");
    fprintf("%8d %12.8f %12.8f %12.4f\n", [x; y; err; rel_err]);
    fprintf("\n");
end

disp("Function (b)");
for h = [0.2, 0.1, 0.05]
    [y_, x_] = euler(@f2, 0, 2, h, x(end));
    y = y_(ismember(x_, x));
    err = f2_y(x) - y;
    rel_err = err ./ f2_y(x);
    fprintf("h = %.2f\n", h);
    fprintf("%8s %12s %12s %12s\n", "x", "y_h(x)", "Error", "Rel. Err");
    fprintf("%8d %12.8f %12.8f %12.4f\n", [x; y; err; rel_err]);
    fprintf("\n");
end