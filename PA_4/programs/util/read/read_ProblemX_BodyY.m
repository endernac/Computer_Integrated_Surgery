function [N_markers, Y, t] = read_ProblemX_BodyY(file_path)
% This function takes in a file path to a ProblemX_BodyY file and parses 
% the data
% Args:
%  file_path - path to text file of CALBODY text file
% Output:
%  N_markers - number of markers in the body
%  Y - Coordinates of markers in row format
%  t - Tip coordinates of body

    % Read first line
    fid = fopen(file_path);
    varNames = strsplit(fgetl(fid), ' ');
    fclose(fid);

    % Parse file
    N_markers = str2double(varNames{1});
    M = readmatrix(file_path,'Range',[2 1]);
    
    Y = M(1:N_markers, :);
    t = M(end, :);
    
end