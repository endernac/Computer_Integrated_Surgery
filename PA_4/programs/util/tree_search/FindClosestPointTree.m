function [d, c] = FindClosestPointTree(s, triangle_tree, d, c)
% This uses the tree and a given point, bound, and current closest point to
% return the newest closest point and distance
% Args:
%   s - (N_points x dim) array of points in row format.
%   triangle_tree - Tree object of meshes.
%   d - (N_points x 1) array of distances corresponding to points in row format.
%   c - (N_points x dim) array of closest points in row format.
% Output:
%   d - (N_points x 1) array of distances corresponding to points in row format.
%   c - (N_points x dim) array of closest points in row format.

    [N_samps, ~] = size(s);
    if nargin < 3
        d = realmax * ones(N_samps, 1);
        c = realmax * ones(size(s));
    end
    for i = 1:N_samps
        [d(i), c(i,:)] = triangle_tree.FindClosestPoint(s(i,:), d, c(i,:));
    end
end