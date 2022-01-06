function [d, a, c] = read_CALREADINGS(file_path)
% This function takes in a file path to a CALBODY file and parses the data
% Args:
%  file_path - path to text file of CALBODY text file
% Returns
%  d - returns coordinates of d_i as a matrix (N_D x 3) dim 
%  a - returns coordinates of a_i as a matrix (N_A x 3) dim
%  c - returns coordinates of c_i as a matrix (N_C x 3) dim

    % Read first line
    fid = fopen(file_path);
    varNames = strsplit(fgetl(fid), ', ');
    fclose(fid);
    N_D = str2double(varNames{1});
    N_A = str2double(varNames{2});
    N_C = str2double(varNames{3});
    N_f = str2double(varNames{4});
    
    M = readmatrix(file_path);
    
    d = zeros(N_D, 3, N_f);
    a = zeros(N_A, 3, N_f);
    c = zeros(N_C, 3, N_f);
    
    cj = 0;
    for i = 1:N_f
        di = cj + 1;
        dj = di + N_D - 1;
        d(:,:,i) = M(di:dj, :);
        ai = dj + 1;
        aj = ai + N_A - 1;
        a(:,:,i) = M(ai:aj, :);
        ci = aj + 1;
        cj = ci + N_C - 1;
        c(:,:,i) = M(ci:cj, :);
    end

end