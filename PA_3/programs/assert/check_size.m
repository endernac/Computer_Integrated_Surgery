function size_bool = check_size(A, B)
% Given A and B, return true if A and B are the same size, regardless of
% dimension of A or B (vector or matrix works)
    size_bool = isequal(size(A), size(B)) || (isvector(A) && isvector(B) && numel(A) == numel(B));
end