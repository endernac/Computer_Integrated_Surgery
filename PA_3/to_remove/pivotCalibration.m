function [p_t, p_pivot] = pivotCalibration(F)
% F is a 4x4xN matrix with multiple homogenous transformations from
% different times/poses of the pivot calibration. Each page represents the
% transform calculated at the time step.
    
    % Make A and b matrices in order to perform least squares
    [A, b] = pivotCalMakeAb(F);
    
    % Use pseudo-inverse to calculate "x"
%     x = (A.' * A) \ A' * b;
    
    % Use linsolve to calculate "x" (LU or QR factorization)
    x = linsolve(A, b);
    
    % Parse x into p_t and p_pivot
    p_t = x(1:3);
    p_pivot = x(4:6);
    
end