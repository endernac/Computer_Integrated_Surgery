function [c_star, d_star] = Find_Closest_Point_Triangle(a, triVert)
% This function takes a matrix of triangle vertices, and a point a, and
% calculates the closest point on the triangle to the point.
% Args:
%  a - a point (1 x 3) in x, y, z dimensions.
%  triVert - A (3 x 3) matrix with the x, y, z dimensions in the rows.
% Returns
%  c_star - closest point to a on the triangle.
%  d_star - distance between a and closest point

    % Take apart vertices
    r = triVert(1,:);
    q = triVert(2,:);
    p = triVert(3,:);
    
    A = [q - p; r - p].';
    b = (a - p).';
    
    x = linsolve(A, b);
    lambda = x(1);
    mu = x(2);
    
    c = p + lambda.'*(q-p) + mu.' * (r - p);
    
    if (lambda < 0)
        c_star = Project_On_Segment(c, r, p);
    elseif (mu < 0)
        c_star = Project_On_Segment(c, p , q);
    elseif ((lambda + mu) > 1)
        c_star = Project_On_Segment(c, q, r);
    else
        c_star = c;
    end 
    d_star = norm(c_star - a);
    
end