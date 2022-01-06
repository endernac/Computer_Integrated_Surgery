%% Test Project On Segment

%% Do straight forward example, 1D line between p and q
% p and q form a line, project point c onto the line
p = [0, 0, 0];
q = [1, 0, 0];
c = [0, 1, 0];

% The projected value c_star should just be [0, 0, 0].
[c_star] = Project_On_Segment(c, p, q);
assert(all(abs(c_star - p) < eps))
disp("Passed simplest test (Essentially 1D)")

%% Add more dimension to the example now, line is in 2D
% p and q form a line, project point c onto the line
p = [0, 0, 0];
q = [1, 1, 0];
c = [0, 1, 0];

% The projected value c_star should be halfway between p and q.
[c_star] = Project_On_Segment(c, p, q);
assert(all(abs(c_star - [0.5, 0.5, 0]) < eps))
disp("Passed basic 2D projection test (45 deg angle)")

%% Try scaled 2D (still halfway between)
% This is to make sure the function operates with different range of input
p = [0, 0, 0];
q = 5*[1, 1, 0];
c = [0, 1, 0];

% The projected value c_star should be halfway between p and q.
[c_star] = Project_On_Segment(c, p, q);
assert(all(abs(c_star - [0.5, 0.5, 0]) < eps))
disp("Passed basic 2D projection test SCALED (45 deg angle)")

%% Try 2D (line NOT at a 45 deg angle)
% again, p and q form a line, project point c onto the line
th = pi/6;
p = [0, 0, 0];
q = 5*[cos(th), sin(th), 0];
c = [0, 1, 0];

% The projected value c_star should be halfway between p and q.
[c_star] = Project_On_Segment(c, p, q);
assert(all(abs(c_star - [cosd(60)*cosd(30), cosd(60)*sind(30), 0]) < eps))
disp("Passed 2D projection test SCALED (30 deg angle)")

disp("Project_On_Segment.m PASSES ALL UNIT TESTS")
