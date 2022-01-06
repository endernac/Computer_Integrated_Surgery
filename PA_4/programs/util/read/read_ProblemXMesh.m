function [N_vertices, N_triangles, V, i] = read_ProblemXMesh(file_path)
% This function takes in a file path to a ProblemXMesh file and parses 
% the data
% Args:
%  file_path - path to text file of CALBODY text file
% Output:
%  N_vertices - Number of vertices in mesh
%  N_triangles - Number of triangles in mesh
%  V - Vertices of triangles in row format
%  i - Indices of triangles in row format.

    % Read first line
    fid = fopen(file_path);
    varNames = strsplit(fgetl(fid), ' ');
    fclose(fid);

    % Parse file
    N_vertices = str2double(varNames{1});
    M = readmatrix(file_path,'Range',[2 1], 'FileType','text');
    
    V = M(1:N_vertices, 1:3);
    N_triangles = M(N_vertices+1,1);
    i = M(N_vertices+2:end, 1:3);
    
end