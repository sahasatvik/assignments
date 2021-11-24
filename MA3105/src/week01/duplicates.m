A = randi(10, 1, 10)

elements = unique(A);
for e = elements
    idx = find(A == e);
    if length(idx) > 1
        disp([e, idx])
    end
end