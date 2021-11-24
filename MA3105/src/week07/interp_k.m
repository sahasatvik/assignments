% Interpolate piecewise with k degree polynomials

function y = interp_k(x_i, y_i, k, x)
    n = length(x_i);
    y = [];
    for i = 1:k:n-k
        pi = lagrange_interpolate(x_i(i:i+k), y_i(i:i+k));
        y = cat(1, y, pi(x(x >= x_i(i) & x < x_i(i+k))'));
    end
    y(end + 1) = y_i(end);
    y = y';
end