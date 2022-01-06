function Ginv = SE3_INV(G)
% Uses SE3 properties to quickly calculate the inverse matrix without real
% concerns about singularity
% Args: 
%     G: Input transformation (SE3)
% Outputs:
%     Ginv: inverse transformation of input

    R = G(1:3,1:3);
    t = G(1:3,4);
    Ginv = [R' -R'*t; zeros(1,3), 1];
end
