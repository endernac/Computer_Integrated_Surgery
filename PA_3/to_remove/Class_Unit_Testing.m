%% Test classes
% Create cube of triangles
vertices = [-1 -1 1;...
            1 -1 1;...
            1 1 1; ... %3
            -1 1 1; ... %4
            1 -1 -1; ...
            1 1 -1;... %6
            -1 -1 -1; ...
            -1 1 -1; ... %8
            1 -1 -1]; %9
            
iVert = [1, 2, 3;... %1
         1, 3, 4;... %2 
         2, 5, 6;... %3
         2, 6, 3;... %4
         5, 7, 8;... %5
         9, 1, 4;... %6
         7, 1, 4;... %7
         7, 4, 8;... %8
         4, 3, 6;... %9
         4, 6, 8;... %10
         2, 7, 5;... %11
         2, 1, 7];
     
 % For every triangle, make a bounding sphere
 BS = [];
 nS = 12;
 for i = 1:nS
     triangle = vertices(iVert(i,:),:);
     [center, radius]= calc_sphere(triangle);
     sphere = BoundingSphere(center, radius);
     BS = [BS; sphere];
 end
 
 