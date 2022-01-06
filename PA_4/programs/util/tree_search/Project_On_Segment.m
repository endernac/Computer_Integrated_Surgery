function [c_star] = Project_On_Segment(c, p, q)
% This function takes a point c and projects it on the line formed by
% the two points p and q, and returns the projection.
% Args:
%   c - (1 x 3) array representing the point to project.
%   p - (1 x 3) array representing a point on the line to project on.
%   q - (1 x 3) array representing a point on the line to project on.
% Output:
%   c_star - the point c projected on the line formed by p-q.

    a = c - p;
    b = q - p;
    lambda = dot(a, b) / dot(b, b);
    lambda_seg = max(0, min(lambda, 1));
    c_star = p + lambda_seg * (q - p);
    
end