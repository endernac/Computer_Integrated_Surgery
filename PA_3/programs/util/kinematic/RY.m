function R = RY(a)
% Given a scalar rotation, return the rotation by a about the y-axis
% Args: 
%     a: scalar rotation value about y axis
% Outputs:
%     R: rotation matrix

R = [cos(a) 0 sin(a);...
     0 1 0;...
     -sin(a) 0 cos(a)];
end