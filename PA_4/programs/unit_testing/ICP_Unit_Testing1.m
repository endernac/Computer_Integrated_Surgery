%% Load data

meshFilename = "Problem4MeshFile.sur";
[N_vertices, N_triangles, Mesh, iMesh] = read_ProblemXMesh(meshFilename);

n_samples = 100;

tri = randi([1,N_triangles],n_samples,1);
sample_pts = zeros(n_samples,3);

for i = 1:size(tri)
    p = Mesh(iMesh(tri(i),:), :);
    
    a = rand(1, 3);
    a = a / sum(a);
    
    sample_pts(i, :) = a * p;
end


%% Test #1: Rotation Only
% Transform mesh
F = SE3(RZ(0.00001), zeros(3,1));
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
[F_reg, s, c] = ICP(F_reg, f_sample, triangle_tree, 50, true);

transformed_points = homoify(F_reg \ homoify(c).');
error = abs(sample_pts - transformed_points);
disp(error)

assert(all(error < 1e-10, 'all'))
test(1) = 1;
