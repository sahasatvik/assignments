x = 0:0.2:1.2;
y = cos(x);

scatter(x, y, 70, 'filled')

% Prepare the difference table

n = length(x);
diffs = zeros(n, n);
diffs(1,:) = y;

% Calculate the divided differences
for i = 1:n-1
    diffs(i + 1, 1:n - i) = (diffs(i, 2:n - i + 1) - diffs(i, 1:n - i)) ./ (x(i + 1:n) - x(1:n - i));
end

% Method 1: roll up the polynomial right to left
% (only used here for producing a smooth plot)

x_ = x(1):0.01:x(end);
y_ = 0;

for i = n:-1:1
    y_ = diffs(i, 1) + (x_ - x(i)) .* y_;
end

% Method 2: roll up the polynomial left to right
% Also keep track of the intermediate p_i(x) values

x__ = [0.1 0.3 0.5];
y__ = ones(n, length(x__)) * y(1);

for i = 2:n
    y__(i,:) = y__(i - 1,:) + prod(x__' - x(1:i - 1), 2)' * diffs(i, 1);
end


hold on
plot(x_, y_)
scatter(x__, y__(end, :), 80, 'x', 'k')
legend("Original data points", "Interpolated polynomial", "Interpolated points")
hold off

disp("Divided difference table:")
disp(diffs)

disp("Interpolation steps (p_i(x)) for x = [0.1, 0.3, 0.5]:")
fprintf("%3s |  p_i(%6.2f)  p_i(%6.2f)  p_i(%6.2f)\n", "i", x__)
fprintf("----+---------------------------------------\n")
fprintf("%3d | %12.8f %12.8f %12.8f\n", [(0:n-1)', y__]')
disp(" ")



% Symbolic evaluation of polynomials p_i(x)
% Uses the Symbolic Math Toolkit

% Note that the coefficients of odd powers vanish as the degree increases

sympref('FloatingPointOutput', true);
sympref('PolynomialDisplayStyle', 'ascend');

syms z p(z)

disp("Interpolating polynomials: ")

p(z) = y(1);
fprintf("p_%d(z) = %s\n", 0, p(z))
for i = 2:n
    p(z) = p(z) + prod(z - x(1: i - 1)) * diffs(i, 1);
    fprintf("p_%d(z) = %s\n", i - 1, vpa(simplify(p(z)), 4))
end
