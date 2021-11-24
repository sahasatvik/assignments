A = [6 2 2; 2 2/3 1/3; 1 2 -1];
b = [-2 1 0]';

% A = [0.02 0.01 0 0; 1 2 1 0; 0 1 2 1; 0 0 100 200];
% b = [0.02 1 4 800]';

x = gauss_elim(A, b, true);

disp("Matrix A")
disp(A)
disp("Vector b")
disp(b)
disp("Solution vector")
disp(x)
disp("Residual b - Ax")
disp(b - A*x)