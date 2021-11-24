function root = bisection(a, b, epsilon, max_iter)

    if a > b
        error("a must be less than b!")
    end
    
    if sign(f(a)) * sign(f(b)) > 0
        error("f(a) and f(b) have the same sign!")
    end
    
    % Format header
    fprintf("%2s %8s %8s %8s %8s %8s %8s\n", "n", "a", "b", "c", "f(a)", "f(b)", "f(c)");
    disp("--------------------------------------------------------")
    
    % Iterate a maximum of max_iter times
    for n = 1:max_iter
        % Bisect
        c = (a + b) / 2;
        
        % Display info
        fprintf("%2d %8.4f %8.4f %8.4f %8.4f %8.4f %8.4f\n", n, a, b, c, f(a), f(b), f(c));
        
        % Check tolerance
        if (b - c) <= epsilon
            break
        end
        
        % Check which side the root is on
        if sign(f(a)) * sign(f(c)) < 0
            b = c;
        else
            a = c;
        end
    end
    root = c;
end

% >> bisection(1, 2, 1e-3, 100)
%  n        a        b        c     f(a)     f(b)     f(c)
% --------------------------------------------------------
%  1   1.0000   2.0000   1.5000  -1.0000  61.0000   8.8906
%  2   1.0000   1.5000   1.2500  -1.0000   8.8906   1.5647
%  3   1.0000   1.2500   1.1250  -1.0000   1.5647  -0.0977
%  4   1.1250   1.2500   1.1875  -0.0977   1.5647   0.6167
%  5   1.1250   1.1875   1.1562  -0.0977   0.6167   0.2333
%  6   1.1250   1.1562   1.1406  -0.0977   0.2333   0.0616
%  7   1.1250   1.1406   1.1328  -0.0977   0.0616  -0.0196
%  8   1.1328   1.1406   1.1367  -0.0196   0.0616   0.0206
%  9   1.1328   1.1367   1.1348  -0.0196   0.0206   0.0004
% 10   1.1328   1.1348   1.1338  -0.0196   0.0004  -0.0096
%
% ans =
% 
%     1.1338