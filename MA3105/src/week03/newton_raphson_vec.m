function root = newton_raphson_vec(x_0, max_iter, epsilon, alpha)
    
    % Set initial values
    x = zeros(max_iter + 1, 1);
    x(1) = x_0;
   
    
    % Iterate
    for n = 2:max_iter
        x(n) = x(n - 1) - f(x(n - 1)) / fprime(x(n - 1));
        if abs(x(n) - x(n - 1)) <= epsilon
            break
        end
    end

    delta_x = [0; x(2:n) - x(1:n-1)];
    rel_err = (alpha - x) / alpha;
    
    % Display all info _at the end_
    fprintf("%2s %8s %8s %12s %12s\n", "n", "x_n", "f(x_n)", "Delta x_n", "Rel. error");
    disp("----------------------------------------------");
    fprintf("%2d %8.4f %8.4f %12.4f %12.4f\n", [(0:n-1)', x(1:n), f(x(1:n)), delta_x, rel_err(1:n)]');
    
    root = x(n);
end

% >> alpha = 1.134724138
% >> newton_raphson_vec(1.5, 100, 1e-3, alpha)
%  n      x_n   f(x_n)    Delta x_n   Rel. error
% ----------------------------------------------
%  0   1.5000   8.8906       0.0000      -0.3219
%  1   1.3005   2.5373      -0.1995      -0.1461
%  2   1.1815   0.5385      -0.1190      -0.0412
%  3   1.1395   0.0492      -0.0420      -0.0042
%  4   1.1348   0.0006      -0.0047      -0.0000
%  5   1.1347   0.0000      -0.0001      -0.0000
% 
% ans =
% 
%    1.134724145316218