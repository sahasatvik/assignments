function x = jacobi(A, b, x0, tol, maxit)
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
        for j = 1:n
            x(j) = (b(j) - A(j, :) * x0 + A(j, j) * x0(j)) / A(j, j);
        end
        
        err = max(abs(x - x0));
        if err < tol
            break
        end
        
        x0 = x;
        
%         disp([i, x']);
    end
end