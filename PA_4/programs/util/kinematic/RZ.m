function R = RZ(a)
% Given a scalar rotation, return the rotation by a about the z-axis
% Args: 
%     a: scalar rotation value about z axis
% Outputs:
%     R: rotation matrix

R = [cos(a) -sin(a) 0;...
     sin(a) cos(a) 0;...
     0 0 1];
end