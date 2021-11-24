function x = gauss_seidel(A, b, x0, tol, maxit)
    [m, n] = size(A);
    if m ~= n
        error("A is not a square matrix.")
    end
    
    if length(b) ~= n
        error("b is not of the desired length.")
    end
    if length(x0) ~= n
        error("x0 is not of the desired length.")
    end
    
    x = x0;
    
    for i = 1:maxit
        x(1) = (b(1) - A(1, 2:n) * x0(2:n)) / A(1, 1);
        for j = 2:n-1
            x(j) = (b(j) - A(j, 1:j-1) * x(1:j-1) - A(j, j+1:n) * x0(j+1:n)) / A(j,j);
        end
        x(n) = (b(n) - A(n, 1:n-1) * x(1:n-1)) / A(n, n);
        
        err = max(abs(x - x0));
        if err < tol
            break
        end
        
        x0 = x;
        
%         disp([i, x'])
    end
end