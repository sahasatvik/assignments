function root = newton_raphson(x_0, max_iter, epsilon, alpha)
    
    % Header info
    fprintf("%2s %8s %8s %12s %12s\n", "n", "x_n", "f(x_n)", "Delta x_n", "Rel. error");
    disp("----------------------------------------------")
    
    % Initial values
    rel_err = (alpha - x_0) / alpha;
    fprintf("%2d %8.4f %8.4f %12s %12.4f\n", 0, x_0, f(x_0), "----", rel_err);
    
    for n = 1:max_iter
        % Update values
        x_new = x_0 - f(x_0) / fprime(x_0);
        delta_x = x_new - x_0;
        rel_err = (alpha - x_new) / alpha;
        
        % Display info
        fprintf("%2d %8.4f %8.4f %12.4f %12.4f\n", n, x_new, f(x_new), delta_x, rel_err);
        
        % Check tolerance
        if abs(x_new - x_0) <= epsilon
            break
        end
        
        x_0 = x_new;
    end
    
    root = x_new;
end

% >> alpha = 1.134724138
% >> newton_raphson(1.5, 100, 1e-3, alpha)
%  n      x_n   f(x_n)    Delta x_n   Rel. error
% ----------------------------------------------
%  0   1.5000   8.8906         ----      -0.3219
%  1   1.3005   2.5373      -0.1995      -0.1461
%  2   1.1815   0.5385      -0.1190      -0.0412
%  3   1.1395   0.0492      -0.0420      -0.0042
%  4   1.1348   0.0006      -0.0047      -0.0000
%  5   1.1347   0.0000      -0.0001      -0.0000
% 
% ans =
% 
%    1.134724145316218