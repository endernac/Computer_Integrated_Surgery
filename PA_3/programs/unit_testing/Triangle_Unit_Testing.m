%% Unit Testing for Triangle.m Class
%% This part will make sure that the class constructor is working properly
% Unit test constructor
vertices = [0, 0, 0; ...
            1, 0, 0; ...
            0, 1, 0];
test = Triangle(vertices);

% The center should be the mean along the columns of the vertices
assert(all((abs(mean(vertices) - test.center)) < eps, 'all'))
disp("The center is calculated correctly")

%% Unit test class functions methods
% Skip closest point since that is unit tested separately and sortPoint since
% that is tested in the default constructor

%% Test Enlarge Bounds
% With identity tansformation and the center as the inputs, the lower bound
% should be the minimum over all dimensions of all vertices, and the upper 
% bound should be the maximum of all vertices.

F = eye(4);
% The calculated LB and UB
[LB, UB] = test.EnlargeBounds(F, [1/3, 1/3, 0], [1/3, 1/3, 0]);
LB_real = min(vertices,[],1);
UB_real = max(vertices,[],1);
assert(all(abs(LB_real-LB) < eps, 'all'))
disp("EnlargeBounds: LB test #1 passed")
assert(all(abs(UB_real-UB) < eps, 'all'))
disp("EnlargeBounds: UB test #1 passed")

% Now do the same test but rotate the bounds 180 degrees in the Z
% direction, and with lower/upper bound inputs that are not only within the
% mesh LB/UB

F = SE3(RZ(pi), [0;0;0]);
[LB, UB] = test.EnlargeBounds(F, [1/3, -5, -1], [2, 1/3, 0]);
LB_real = [-1, -5, -1];
UB_real = [2, 1/3, 0];
assert(all(abs(LB_real-LB) < eps, 'all'))
disp("EnlargeBounds: LB test #2 passed")
assert(all(abs(UB_real-UB) < eps, 'all'))
disp("EnlargeBounds: UB test #2 passed")

%% Test BoundingBox 
% This should always give +/- infinity as the bounds of the box, no matter the
% transformation, since we are just initializing the bounds.
F = eye(4);
[LB, UB] = test.BoundingBox(F);
% LB_real = min(vertices,[],1);
% UB_real = max(vertices,[],1);
LB_real = -inf;
UB_real = inf;
assert(all(abs(LB_real-LB.') < eps, 'all'))
disp("BoundingBox: LB test #1 passed")
assert(all(abs(UB_real-UB.') < eps, 'all'))
disp("BoundingBox: UB test #1 passed")

% Again 180 deg flip in the z direction
F = SE3(RZ(pi), [0;0;0]);
[LB, UB] = test.BoundingBox(F);
assert(all(abs(LB_real-LB.') < eps, 'all'))
disp("BoundingBox: LB test #2 passed")
assert(all(abs(UB_real-UB.') < eps, 'all'))
disp("BoundingBox: UB test #2 passed")

% Again with random SE3
F = randomSE3();
[LB, UB] = test.BoundingBox(F);
assert(all(abs(LB_real-LB.') < eps, 'all'))
disp("BoundingBox: LB test #3 passed")
assert(all(abs(UB_real-UB.') < eps, 'all'))
disp("BoundingBox: UB test #3 passed")