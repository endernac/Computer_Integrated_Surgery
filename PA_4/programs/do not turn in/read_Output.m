% function [N_samps, c, d, diff_mag] = read_Output(file_path)
function M = read_Output(file_path)

    % Read first line
    fid = fopen(file_path);
    varNames = strsplit(fgetl(fid), ' ');
    fclose(fid);

    % Parse file
    N_samps = str2double(varNames{1});
    M = readmatrix(file_path,'Range',[2 1], 'FileType','text');
    
%     d = M(:, 1:3);
%     c = M(:, 1:3);
%     diff_mag = M(:, end);

end