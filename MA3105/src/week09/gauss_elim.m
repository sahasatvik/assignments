function x = gauss_elim(A, b, pivot)
    [m, n] = size(A);
    if m ~= n
        error("A is not a square matrix.")
    end
    
    if length(b) ~= n
        error("b is not of the desired length.")
    end
    
    % Augment
    A = [A, b];
    
    % Triangularize
    for i = 1:n
        if pivot
            % Choose a pivot element
            [maxab, idx] = max(abs(A(i:n, i)));
            idx = idx + i - 1;
        
            if maxab < eps
                error("Singular matrix.")
            end
               
            % Swap rows
            if idx ~= i
                temp = A(i, :);
                A(i, :) = A(idx, :);
                A(idx, :) = temp;
            end
        end
        
        % Normalize diagonal
        A(i, :) = A(i, :) / A(i, i);
        
        % Elimination
        for k = i+1:n
            A(k, :) = A(k, :) - A(k, i) * A(i, :);
        end    
    end
    
    % Back substitution
    for i = n:-1:2
        for k = 1:i-1
            A(k, :) = A(k, :) - A(k, i) * A(i, :);
        end
    end
    x = A(:, n + 1);
end
