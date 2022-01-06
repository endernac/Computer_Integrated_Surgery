function G = read_EM_NAV(file_path)
% This function takes in a file path to a CT-FIDUCIALS file and parses the 
% data
% Args:
%  file_path - path to text file of CALBODY text file
% Returns
%  G - N_B x 3 x N_G matrix that corresponds to the coordinates where the
%  probe is in contact with the corresponding CT fiducials.

    % Read first line
    fid = fopen(file_path);
    varNames = strsplit(fgetl(fid), ',');
    fclose(fid);

    % Parse file
    N_G = str2double(varNames{1});
    N_f = str2double(varNames{2});
    M = readmatrix(file_path,'Range',[2 1]);
    
    G = zeros(N_G, 3, N_f);
    
    % Loop over number of frames
    for i = 1:N_f
        j = N_G*(i-1)+1;
        G(:,:,i) = M(j:(j+N_G-1), :);
    end
    
end