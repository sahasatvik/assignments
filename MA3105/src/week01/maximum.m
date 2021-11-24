lo = 1;
hi = 20;
step = 2;

A = lo:step:hi
n = length(A)

permutation = randperm(n);
B = A(permutation)

max_ = -Inf;
idx = 0;

for i = 1:n
    if B(i) > max_
        max_ = B(i);
        idx = i;
    end
end

disp(max_)
disp(idx)