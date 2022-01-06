% This unit test makes sure that the calc_sphere function works correctly
% by using a simple triangle to test where the radius and center can be
% calculated easily, and is verified against that


% This triangle is right angle isosceles.
triangle = [0, 0, 0; 1, 0, 0; .5, .5, 0];
% radius should be 0.5, q should be [0, 0.5, 0]
[q, r] = calc_sphere(triangle);
assert(r-0.5 < eps)
assert(all(q - [0.5, 0, 0] < eps))
disp("Function works when q = a + b / 2")

% Flip triangle around but has same lengths (still right angle isosceles) 
triangle = [0, 0, 0; .5, .5, 0; 1, 0, 0];
% radius should be 0.5, q should be [0.5, 0, 0]
[q, r] = calc_sphere(triangle);
assert(r-0.5 < eps)
assert(all(q - [0.5, 0, 0] < eps))
disp("Function works when q != a + b / 2")

