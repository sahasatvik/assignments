function root = secant(x, max_iter, epsilon, alpha)
    
    % Iterate
    for n = 3:max_iter
        x(n) = x(n - 1) - f(x(n - 1)) * (x(n - 1) - x(n - 2)) / (f(x(n - 1)) - f(x(n - 2)));
        if abs(x(n) - x(n - 1)) <= epsilon
            break
        end
    end

    % Calculate errors
    delta_x = [0; x(2:n) - x(1:n-1)];
    abs_err = alpha - x;
    
    % Display all info at the end
    fprintf("%2s %8s %8s %12s %12s\n", "n", "x_n", "f(x_n)", "Delta x_n", "Abs. error");
    disp("----------------------------------------------");
    fprintf("%2d %8.4f %8.4f %12.4f %12.4f\n", [(0:n-1)', x, f(x), delta_x, abs_err]');
    
    root = x(n);
end

% >> alpha = 1.134724138
% >> secant([2; 1], 100, 1e-3, alpha)
%  n      x_n   f(x_n)    Delta x_n   Abs. error
% ----------------------------------------------
%  0   2.0000  61.0000       0.0000      -0.8653
%  1   1.0000  -1.0000      -1.0000       0.1347
%  2   1.0161  -0.9154       0.0161       0.1186
%  3   1.1906   0.6575       0.1744      -0.0559
%  4   1.1177  -0.1685      -0.0729       0.0171
%  5   1.1325  -0.0224       0.0149       0.0022
%  6   1.1348   0.0010       0.0023      -0.0001
%  7   1.1347  -0.0000      -0.0001       0.0000
%
% ans =
% 
%     1.1347