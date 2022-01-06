function F = Point_Cloud_Registration(A, B)
% This function does point cloud registration for two given inputs.
% note, A = lower letter, B = upper letter
% Args: 
%     A: Matrix of N_A x 3, where one row is one point with an x, y, z
%     dimension. A must be defined from the calibration object base for
%     this to work properly.
%     B: Matrix of N_B x 3, where one row is one point with an x, y, z
%     dimension. B must be defined from the tracker base for this to work
%     properly.
% Outputs:
%     F: The transformation as defined from A to B
 

    % They must be the same size!
    assert(check_size(A, B), "A and B must be the same size");
    [N, ~] = size(A);

    % Zero Mean Data
    A_bar = mean(A, 1);
    B_bar = mean(B, 1);
    A_ = A - A_bar;
    B_ = B - B_bar;

    % Calculate H from slides
    H = zeros(3,3);
    for i = 1:N
        a = A_(i, :);
        b = B_(i, :);
        H_temp = [a(1)*b(1), a(1)*b(2), a(1)*b(3);
                  a(2)*b(1), a(2)*b(2), a(2)*b(3);
                  a(3)*b(1), a(3)*b(2), a(3)*b(3)];
        H = H + H_temp;
    end
    
    % Calculate R using SVD of H
    [U, ~, V] = svd(H);
    R = V * U.';

    % Catch corner cases (R is a reflection)
    if det(R) < 0
        V_prime = V;
        V_prime(:, 3) = -V(:, 3);
        R = V_prime * U.';
    end
    
    % Calculate p
    p = B_bar.' - R*A_bar.';
    
    % Return homogeneous transformation
    F = SE3(R, p);
    
end