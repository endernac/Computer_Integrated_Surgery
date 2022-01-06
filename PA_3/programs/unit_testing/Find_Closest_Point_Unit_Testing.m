%% Test if given any vertex, that Find_Closest_Point gives vertex back

disp("Test if given any vertex, that Find_Closest_Point gives vertex back")
triangle = Vert(Vidxs(1,:),:);
for i = 1:3
    point = triangle(i,:);
    c_star = Find_Closest_Point(point, triangle);
    assert(all(abs(c_star - point) < eps))
    disp("Passed Test # " + num2str(i))
end

%% Now test edge cases

disp("Test if given any point on an edge, that Find_Closest_Point gives vertex back")

for i = 1:2
    % interpolate between vertices
    point = (triangle(i,:) + triangle(i+1,:))/2;
    c_star = Find_Closest_Point(point, triangle);
    assert(all(abs(c_star - point) < 1e-12))
    disp("Passed Test # " + num2str(i+3))
end

%% Now try with offset by normal of triangle 
% In other words, take a point on the surface, project it off of the
% surface in the normal direction, and expect the same point back

disp("Test if point at vertex, but offset by normal of triangle surface")
% If b, r, s are points on a plane, make vector r-b, s-b and take cross product
% to get normal
r = triangle(1,:);
b = triangle(2,:);
s = triangle(3,:);
triangleNorm = cross((r-b), (s-b));
for i = 1:3
    point = triangle(i,:) + triangleNorm;
    c_star = Find_Closest_Point(point, triangle);
    assert(all(abs(c_star - triangle(i,:)) < 1e-12))
    disp("Passed Test # " + num2str(5+i))
end

%% Do same as above but with midpoint on edges

disp("Test if given any point on an edge (offset by triangle norm), that Find_Closest_Point gives vertex back")

for i = 1:2
    point = (triangle(i,:) + triangle(i+1,:))/2 ;
    c_star = Find_Closest_Point(point+ triangleNorm, triangle);
    assert(all(abs(c_star - point) < 1e-12))
    disp("Passed Test # " + num2str(i+8))
end

%%



