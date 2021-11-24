function t = root_newton(f, dfdt, t0, tol, maxiter)
    for i = 1:maxiter
        t = t0 - f(t0) / dfdt(t0);
        if abs((t - t0) / t) < tol
            break
        end
        t0 = t;
    end
end
