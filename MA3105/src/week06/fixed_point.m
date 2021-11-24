% Usage example: fixed_point(@f3, 0.5, 100, 1e-3)

function [root, n, x] = fixed_point(f, x_0, max_iter, epsilon)
    x = [x_0; 0];
   
    % Iterate
    for n = 2:max_iter
        x(n) = f(x(n - 1));
        if abs(x(n) - x(n - 1)) <= epsilon
            break
        end
    end
    
    root = x(n);
    delta_x = [0; x(2:n) - x(1:n-1)];
    
    % Display all info at the end
    fprintf("%2s %12s %12s %12s\n", "n", "x_n", "f(x_n)", "Delta x_n");
    disp("------------------------------------------");
    fprintf("%2d %12.8f %12.8f %12.8f\n", [(0:n-1)', x, [x(2:end); f(x(n))], delta_x]');

end