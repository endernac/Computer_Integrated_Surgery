function [d, a, c] = read_CALBODY(file_path)
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

    % Parse file
    N_D = str2double(varNames{1});
    N_A = str2double(varNames{2});
    N_C = str2double(varNames{3});
    M = readmatrix(file_path);
    d = M(1:N_D, :);
    a = M((N_D+1):(N_D+N_A), :);
    c = M((N_D+N_A+1):(N_D+N_A+N_C), :);
end