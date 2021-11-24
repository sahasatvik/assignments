% Plot all three functions and the fixed point iteration paths

subplot(1, 3, 1)
[~, ~, x] = fixed_point(@f1, 0.5, 100, 1e-3);
pretty_plot(-12:0.01:3, @f1, x);
title("10 / (x^3 - 1)")
subtitle("Root not found (trapped in cycle)")

subplot(1, 3, 2)
[root, ~, x] = fixed_point(@f2, 0.5, 100, 1e-3);
pretty_plot(0.4:0.01:2, @f2, x);
title("(x + 10)^{0.25}")
subtitle(sprintf("Root at %0.4f", root))

subplot(1, 3, 3)
[root, ~, x] = fixed_point(@f3, 0.5, 100, 1e-3);
pretty_plot(0.4:0.01:7, @f3, x);
title("(x + 10)^{0.5} / x")
subtitle(sprintf("Root at %0.4f", root))