Mesh = [-1 -2  3;...
         1 -2  3;...
         1  2  3;... %3
        -1  2  3;... %4
         1 -2 -3;...
         1  2 -3;... %6
        -1 -2 -3;...
        -1  2 -3;... %8
         1 -2 -3]; %9
                                
iMesh = [1, 2, 3;... %1
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
     
plott = [];
for i=1:12
    triangle = Mesh(iMesh(i,:),:);
    plott = [plott; triangle];
end
x = plott(:,1);
y = plott(:,2);
z = plott(:,3);
figure
scatter3(x, y, z)

save rect_prism.mat