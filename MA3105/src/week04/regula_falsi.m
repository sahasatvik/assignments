function root = regula_falsi(x, max_iter, epsilon, alpha)
    
    if sign(f(x(1))) * sign(f(x(2))) > 0
        error("Incorrect signs!")
    end

    fprintf("%2s %8s %8s %12s %12s\n", "n", "x_n", "f(x_n)", "Delta x_n", "Abs. error");
    disp("----------------------------------------------");
    fprintf("%2d %8.4f %8.4f %12.4f %12.4f\n", 1, x(1), f(x(1)), NaN, alpha - x(1));
    fprintf("%2d %8.4f %8.4f %12.4f %12.4f\n", 2, x(2), f(x(2)), x(2) - x(1), alpha - x(2));
    
    % Iterate
    for n = 3:max_iter
        x(n) = x(n - 1) - f(x(n - 1)) * (x(n - 1) - x(n - 2)) / (f(x(n - 1)) - f(x(n - 2)));
        
        fprintf("%2d %8.4f %8.4f %12.4f %12.4f\n", n, x(n), f(x(n)), x(n) - x(n - 1), alpha - x(n));
        
        % Tolerance check
        if abs(x(n) - x(n - 1)) <= epsilon
            break
        end
        
        % Sign check
        if sign(f(x(n))) * sign(f(x(n - 1))) > 0
            x(n - 1) = x(n - 2);
        end
    end

    root = x(n);
end

% >> alpha = 1.134724138
% >> regula_falsi([2; 1], 100, 1e-3, alpha)