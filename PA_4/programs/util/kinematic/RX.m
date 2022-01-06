function R = RX(a)
% Given a scalar rotation, return the rotation by a about the x-axis
% Args: 
%     a: scalar rotation value about x axis
% Outputs:
%     R: rotation matrix

R = [1 0 0;... 
     0 cos(a) -sin(a);
     0 sin(a) cos(a);];
end