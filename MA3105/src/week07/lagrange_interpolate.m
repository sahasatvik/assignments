% Returns a function which is the Lagrange interpolating polynomial

function p = lagrange_interpolate(x_i, y_i)
    function y = interp(x)
        n = length(x_i);
        y = 0;
        for i = 1:n
            Li = lagrange_basis(x_i, i);
            y = y + (y_i(i) * Li(x));
        end
    end
    p = @interp;
end