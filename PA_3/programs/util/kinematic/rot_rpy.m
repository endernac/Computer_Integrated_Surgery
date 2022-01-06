function R = rot_rpy(q)
% Given a vector with roll, pitch, yaw angles, return the euler angle
% rotation.
% Args: 
%     q: input angle vector, in form [r, p, y]
% Outputs:
%     R: rotation matrix

r = q(1); p = q(2); y = q(3);
R = RZ(y)*RY(p)*RX(r);
end