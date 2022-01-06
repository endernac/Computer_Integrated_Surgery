%% Brute Force Search Unit Testing
% This script uses a brute force search method to check every triangle in the
% mesh to find the closest point on the mesh to the point

% Create cube of triangles
load("cube.mat")
vertices = Mesh;
iVert = iMesh;

%% Now test Find_Closest_Point_Mesh.m

% Test point 1
point = [-2, -2, -2];
closestPoint = Find_Closest_Point_Mesh(point, vertices, (iVert-1));
assert(all(abs(closestPoint - [-1 -1 -1]) < eps))
disp("Passed test #1") 

% Test point 2
point = [2, 2, 2];
closestPoint = Find_Closest_Point_Mesh(point, vertices, (iVert-1));
assert(all(abs(closestPoint - [1 1 1]) < eps))
disp("Passed test #2") 

% Test point 3
point = [2, -2, 2];
closestPoint = Find_Closest_Point_Mesh(point, vertices, (iVert-1));
assert(all(abs(closestPoint - [1 -1 1]) < eps))
disp("Passed test #3") 
disp("Brute Force Method Works")

