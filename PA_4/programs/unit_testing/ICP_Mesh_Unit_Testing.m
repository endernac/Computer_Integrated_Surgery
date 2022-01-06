%% Load data
% bool array of tests
test = zeros(3,1);

meshFilename = "Problem4MeshFile.sur";
[N_vertices, N_triangles, Mesh, iMesh] = read_ProblemXMesh(meshFilename);
n_samples = 200;

tri = randi([1,N_triangles],n_samples,1);
sample_pts = zeros(n_samples,3);

for i = 1:size(tri)
    p = Mesh(iMesh(tri(i),:)+1, :);
    
    a = rand(1, 3);
    a = a / sum(a);
    
    sample_pts(i, :) = a * p;
end


%% Test #1: Rotation Only
% Transform mesh
F = SE3(RZ(0.1), zeros(3,1));
f_sample = homoify(F * homoify(sample_pts).');

Ts = cell(N_triangles, 1);
for i = 1:N_triangles
    Ts{i} = Triangle(Mesh(iMesh(i,:)+1, :));
end
triangle_tree = CovTreeNode(Ts, N_triangles);

% Test ICP.

% Compute sample points s_k, given F_reg
F_reg = eye(4);

% Do ICP algorithm.
[F_reg, s, c, ~, ~] = ICP(F_reg, f_sample, triangle_tree, 50, 3, true);

error = abs(sample_pts - s);
disp(error)

assert(all(error < 5e-3, 'all'))
test(1) = 1;

%% Test #2: Translation Only
% Transform mesh
F = SE3(eye(3), rand(3,1)*.3);
f_sample = homoify(F * homoify(sample_pts).');

Ts = cell(N_triangles, 1);
for i = 1:N_triangles
    Ts{i} = Triangle(Mesh(iMesh(i,:)+1, :));
end
triangle_tree = CovTreeNode(Ts, N_triangles);

% Test ICP.

% Compute sample points s_k, given F_reg
F_reg = eye(4);

% Do ICP algorithm.
[F_reg, s, c, ~, ~] = ICP(F_reg, f_sample, triangle_tree, 50, 3, true);

error = abs(sample_pts - s);
disp(error)

assert(all(mean(error) < 5e-3, 'all'))
test(2) = 1;


%% Test #1: Rotation Only
% Transform mesh
F = SE3(rot_rpy(rand(3,1)*.1), rand(3,1)*.3);
f_sample = homoify(F * homoify(sample_pts).');

Ts = cell(N_triangles, 1);
for i = 1:N_triangles
    Ts{i} = Triangle(Mesh(iMesh(i,:)+1, :));
end
triangle_tree = CovTreeNode(Ts, N_triangles);

% Test ICP.

% Compute sample points s_k, given F_reg
F_reg = eye(4);

% Do ICP algorithm.
[F_reg, s, c, ~, ~] = ICP(F_reg, f_sample, triangle_tree, 50, 3, true);

error = abs(sample_pts - s);
disp(error)

assert(all(mean(error) < 5e-3, 'all'))
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
