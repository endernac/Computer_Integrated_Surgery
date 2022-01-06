function G = randomSE3() 
    % Generates random rotation matrix
    R = rot_rpy(rand(3,1)*2*pi);
    % Generates random translation
    t = rand(3,1);
    % Appends to correct format
    G = SE3(R, t);
end