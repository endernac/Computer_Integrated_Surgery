function [q, rho] = calc_sphere(triangle)
    a = triangle(1,:);
    b = triangle(2,:);
    c = triangle(3,:);
    f = (a + b)/2;
    
    bool1 = dot(b-f, b-f) - dot(a-f, a-f) < eps;
    bool2 = dot(c-f, c-f) - dot(a-f, a-f) < eps;
    bool3 = dot(cross(b-a, c-a), f-a) < eps;
    
    if ((bool1 && bool2) && bool3)
        q = f;
    else
        u = a - f;
        v = c - f;
        d = cross(cross(u, v), u);

        gamma = (dot(v, v) - dot(u,u))/(dot(2*d, v-u));
        if gamma <= 0
            lambda = 0;
        else
            lambda = gamma;
        end
        q = f + lambda*d;
    end
    rho = norm(q-a);
end