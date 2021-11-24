x1 = [0 1 3];
y1 = [1 3 5];

x2 = [0 1 3 4 7];
y2 = [1 3 49 129 813];

subplot(1, 2, 1)
x = 0:0.1:x1(end);
hold on
plot(x, interp_k(x1, y1, 1, x), '-*')
% plot(x, 2*x + 1, '-k')
% plot(x, x + 2, '-k')
plot(x, interp_k(x1, y1, 2, x), '-*')
% plot(x, -x.^2 / 3 + 7*x / 3 + 1, '-k')
scatter(x1, y1, 'k', 'filled')
hold off
title("Part (a)")
legend("p_1(x)", "p_2(x)", "Data")

subplot(1, 2, 2)
x = 0:0.1:x2(end);
hold on
plot(x, interp_k(x2, y2, 1, x), '-*')
plot(x, interp_k(x2, y2, 2, x), '-*')
scatter(x2, y2, 'k', 'filled')
hold off
title("Part (b)")
legend("p_1(x)", "p_2(x)", "Data")

% Writeup (only for part (a))

disp("(I) Consider the data points (x1, y1) and (x2, y2).")
disp("In order to perform a linear interpolation, we have:")
disp(" ")
disp("          x - x1       x - x2   ")
disp("  p(x) = ------- y1 + ------- y2")
disp("         x2 - x1      x1 - x2   ")
disp(" ")
disp("Simplifying, we have")
disp(" ")
disp("         y2 - y1          y2 - y1   ")
disp("  p(x) = ------- x + y1 - ------- x1")
disp("         x2 - x1          x2 - x1   ")
disp(" ")
disp("For instance, the linear polynomials in part (a) are")
disp(" ")
disp("         2x + 1")
disp("          x + 2")
disp(" ")
disp(" ")
disp("(II) Consider the data points (x1, y1), (x2, y2), (x3, y3).")
disp("In order to perform a quadratic interpolation in (a), we")
disp("calculate the basis polynomials.")
disp(" ")
disp("          (x - 1)(x - 3)   x^2 - 4x + 3")
disp("  L1(x) = -------------- = ------------")
disp("          (0 - 1)(0 - 3)          3    ")
disp(" ")
disp("          (x - 0)(x - 3)   -x^2 + 3x")
disp("  L2(x) = -------------- = ---------")
disp("          (1 - 0)(1 - 3)       2    ")
disp(" ")
disp("          (x - 0)(x - 1)   x^2 - x")
disp("  L3(x) = -------------- = -------")
disp("          (3 - 0)(3 - 1)      6   ")
disp(" ")
disp("Thus, the interpolating polynomial is simply")
disp(" ")
disp("  p(x) = y1 L1(x) + y2 L2(x) + y3 L3(x)")
disp(" ")
disp("         -x^2     7x     ")
disp("       = ----- + ---- + 1")
disp("           3       3     ")