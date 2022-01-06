function isRotation = check_rotation(R)

isRotation = (check_equal(det(R), 1) & (det(R) > 0) & check_orthogonal(R));

end

function isOrthogonal = check_orthogonal(R)

    % If orthogonal, the following is true
    identity = (R.' * R);
    % Then check_diff should be 0 (accounting for floating points)
    check_diff = identity - eye(3);
    
    % check every element of the difference to see if its equal
    isOrthogonal = zeros(3,3);
    for i = 1:3
        for j = 1:3
            isOrthogonal(i, j) = check_equal(check_diff(i, j), 0);
        end
    end
    
    % return a single value, 1 if true, != 1 if not true.
    isOrthogonal = sum(isOrthogonal, 'all') / 9;
    
end