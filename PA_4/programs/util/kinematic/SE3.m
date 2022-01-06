function G = SE3(R,t)
% Quickly appends rotation and transformation matrix into correct format
% Args: 
%     R: Input rotation (3x3 matrix)
%     t: Input translation (3x1 vector)
% Outputs:
%     G: Appended transformation

    G = [R t; zeros(1,3), 1];
end