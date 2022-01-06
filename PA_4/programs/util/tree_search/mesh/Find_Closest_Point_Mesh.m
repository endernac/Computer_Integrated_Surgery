function [c_closest] = Find_Closest_Point_Mesh(point, Mesh, iMesh)
% This function implements brute force search for closest point on mesh 
% via a linear search that keeps track of the closest point and minimum 
% distance.
% Args:
%   point - Point to conduct linear search on, (1 x 3) array.
%   Mesh - Vertices of the mesh.
%   iMesh - Indices for corresponding triangle (or other mesh shape).
% Output:
%   c_closest - closest point found to the mesh (1 x 3) array.

    % Check every triangle to point
    [N_triangles, ~] = size(iMesh); 
    % Initialize search
    triangle = Mesh(iMesh(1,:)+1,:);
    [c_closest, d_closest] = Find_Closest_Point_Triangle(point, triangle);

    for i = 2:N_triangles
        triangle = Mesh(iMesh(i,:)+1,:);
        [c, d] = Find_Closest_Point_Triangle(point, triangle);

        if (d < d_closest)
            d_closest = d;
            c_closest = c;
        end
    end
end