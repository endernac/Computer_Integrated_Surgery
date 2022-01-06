function [A, b] = pivotCalMakeAb(F)
% F is a 4x4xN matrix with multiple homogenous transformations from
% different times/poses of the pivot calibration. Each page represents the
% transform calculated at the time step. This returns the matrix A of size
% 3Nx6, and vector b, 3Nx1, to perform least squares on (or potentially 
% other methods).

    % Init number of frames
    [~, ~, N] = size(F);
    
    % Init A and b 
    A = zeros(3*N, 6);
    b = zeros(3*N, 1);
    
    % Assign A and b
    for i = 1:N
        R = F(1:3, 1:3, i);
        i_start = 3*(i-1)+1;
        i_end = i_start + 2;
        A(i_start:i_end, 1:3) = R;
        A(i_start:i_end, 4:6) = -eye(3);
        b(i_start:i_end) = -F(1:3, 4, i);
    end
end