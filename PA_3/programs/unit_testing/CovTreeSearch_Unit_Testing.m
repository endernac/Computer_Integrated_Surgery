%% Build CovTree
% This script unit tests the covariance tree search by building a tree
% based on either a cube or a rectangular prism versus a point where the
% known closest point is.

%% Make covariance tree
% Make cell of triangles, pick either a cube or rectangular box
% load("cube.mat")
load("rect_prism.mat")
N_triangles = length(iMesh);
Ts = cell(N_triangles, 1);
for i = 1:N_triangles
    Ts{i} = Triangle(Mesh(iMesh(i,:), :));
end

% put into datastructure
triangle_tree = CovTreeNode(Ts, N_triangles);

%% Search covariance tree for closest point
% Search tree for point closes to s_k
bound = realmax;
closest = [realmax, realmax, realmax];
s = [-4, -4, -4];
[~, c_test] = triangle_tree.FindClosestPoint(s, bound, closest);
assert(all(abs([-1, -2, -3]-c_test)<eps), 'all')
disp("Tree search matches hand-calculated value")

c_star = Find_Closest_Point_Mesh(s, Mesh, iMesh-1);
assert(all(abs(c_star-c_test)<eps), 'all')
sprintf("Tree search matches BF search for point %d %d %d", s(1), s(2), s(3))


% Search tree for point closes to s_k
bound = realmax;
closest = [realmax, realmax, realmax];
s = [4, 4, 4];
[~, c_test] = triangle_tree.FindClosestPoint(s, bound, closest);
assert(all(abs([1, 2, 3]-c_test)<eps), 'all')
disp("Tree search matches hand-calculated value")

c_star = Find_Closest_Point_Mesh(s, Mesh, iMesh-1);
assert(all(abs(c_star-c_test)<eps), 'all')
sprintf("Tree search matches BF search for point %d %d %d", s(1), s(2), s(3))

% Search tree for point closes to s_k
bound = realmax;
closest = [realmax, realmax, realmax];
s = [-5, 3, 2];
[~, c_test] = triangle_tree.FindClosestPoint(s, bound, closest);
assert(all(abs([-1, 2, 2]-c_test)<eps), 'all')
disp("Tree search matches hand-calculated value")

c_star = Find_Closest_Point_Mesh(s, Mesh, iMesh-1);
assert(all(abs(c_star-c_test)<eps), 'all')
sprintf("Tree search matches BF search for point %d %d %d", s(1), s(2), s(3))

% generate a bunch or random points and ensure that covariance tree closest
% point matches the BF search
for i = 1:1000
    s = 50 * (rand(1,3) - [0.5, 0.5, 0.5]);
    bound = realmax;
    closest = [realmax, realmax, realmax];
    [~, c_test] = triangle_tree.FindClosestPoint(s, bound, closest);
    c_star = Find_Closest_Point_Mesh(s, Mesh, iMesh-1);
    assert(all(abs(c_star-c_test)<1e-13), 'all')
end
disp("Random tests passed")

disp("All tests passed")
