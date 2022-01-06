%%
clear all
clc

% bool array of tests
test = zeros(3,1);

% Make cell of triangles, pick either a cube or rectangular box
load("rect_prism.mat")
N_triangles = length(iMesh);

%% Test #1: Rotation Only
% Transform mesh
F = SE3(RZ(pi/4), zeros(3,1));
Augmented_Mesh = homoify(F * homoify(Mesh).');

% Load transformed mesh into tree
Ts = cell(N_triangles, 1);
for i = 1:N_triangles
    Ts{i} = Triangle(Augmented_Mesh(iMesh(i,:), :));
end
triangle_tree = CovTreeNode(Ts, N_triangles);

% Test ICP.

% Compute sample points s_k, given F_reg
F_reg = eye(4);

% Do ICP algorihtm.
[F_reg, s, c, ~, ~] = ICP(F_reg, Mesh, triangle_tree, 1000, 3, false);

transformed_points = homoify(F_reg \ homoify(c).');
error = abs(transformed_points - Mesh);
disp(error)

assert(all(error < 1e-10, 'all'))
test(1) = 1;

%% Test #2: Small Translation Only
% Transform mesh
F = SE3(eye(3), rand(3,1));
Augmented_Mesh = homoify(F * homoify(Mesh).');

% Load transformed mesh into tree
Ts = cell(N_triangles, 1);
for i = 1:N_triangles
    Ts{i} = Triangle(Augmented_Mesh(iMesh(i,:), :));
end
triangle_tree = CovTreeNode(Ts, N_triangles);

% Compute sample points s_k, given F_reg

% Do ICP algorihtm.
[F_reg, s, c, ~, ~] = ICP(eye(4), Mesh, triangle_tree, 1000, 3, false);

transformed_points = homoify(F_reg \ homoify(c).');
error = abs(transformed_points - Mesh);
assert(all(error < 1e-10, 'all'))
disp(error)

test(2) = 1;

%% Test #3: XYZ Rotation + Translation
% Transform mesh
F = SE3(rot_rpy(rand(3,1)*pi/2), rand(3,1));
Augmented_Mesh = homoify(F * homoify(Mesh).');

% Load transformed mesh into tree
Ts = cell(N_triangles, 1);
for i = 1:N_triangles
    Ts{i} = Triangle(Augmented_Mesh(iMesh(i,:), :));
end
triangle_tree = CovTreeNode(Ts, N_triangles);

% Compute sample points s_k, given F_reg

% Do ICP algorihtm.
[F_reg, s, c, ~, ~] = ICP(eye(4), Mesh, triangle_tree, 1000, 3, false);

transformed_points = homoify(F_reg \ homoify(c).');
error = abs(transformed_points - Mesh);
disp(error)
assert(all(error < 1e-10, 'all'))

test(3) = 1;


%%
if test(1) == 1
    disp("Rotation Only Test Passed")
end
if test(2) == 1
    disp("Translation Only Test Passed")
end
if test(3) == 1
    disp("Random Transformation Test Passed")
end
