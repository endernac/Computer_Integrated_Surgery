function v_homo = homoify(v)
% given input vector(s) v, append 1 to end to make homogeneous or
% remove 1 from the end depending on the conversion. Does not work with
% pages.
% Args: 
%     v: input vector
% Outputs:
%     v_homo: output vector/matrix in homogenous or non-homogenous
%     form. Each row is a vector.

    [n, m] = size(v);
    if m == 3
        v_homo = [v, ones(n, 1)];
    elseif n == 3
        v_homo = [v.', ones(m, 1)];
    end
    
    if m == 4
        v_homo = v(:,1:(m-1));
    elseif n == 4
        v_homo = v(1:(n-1),:).';
    end
end