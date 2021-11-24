% A = [6 2 2; 2 2/3 1/3; 1 2 -1];
% b = [-2 1 0]';

% A = [0.02 0.01 0 0; 1 2 1 0; 0 1 2 1; 0 0 100 200];
% b = [0.02 1 4 800]';

A = [9 1 1; 2 10 3; 3 4 11];
b = [10 19 0]';

x = gauss_seidel(A, b, [0 0 0]', 1e-3, 100);

disp("Matrix A")
disp(A)
disp("Vector b")
disp(b)
disp("Solution vector")
disp(x)
disp("Residual b - Ax")
disp(b - A*x)