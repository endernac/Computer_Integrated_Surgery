function b = read_CT_FIDUCIALS(file_path)
% This function takes in a file path to a CT-FIDUCIALS file and parses the 
% data
% Args:
%  file_path - path to text file of CALBODY text file
% Returns
%  b - Nb+1 x 3 matrix that corresponds to the CT fiducial coordinates bj

    % Read first line
    fid = fopen(file_path);
    varNames = strsplit(fgetl(fid), ',');
    fclose(fid);

    % Parse file
    N_B = str2double(varNames{1});
    b = readmatrix(file_path);
end