% Returns the i-th Lagrange polynomial in the basis

function p = lagrange_basis(x_i, i)
    function y = L(x)
        X = x_i([1:i-1, i+1:end]);
        y = prod((x - X) ./ (x_i(i) - X), 2);
    end
    p = @L;
end