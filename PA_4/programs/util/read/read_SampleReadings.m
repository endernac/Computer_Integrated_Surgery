function [N_D, N_samps, A, B, D] = read_SampleReadings(file_path, N_A, N_B)
% This function takes in a file path to a SampleReadings file and parses 
% the data.
% Args:
%  file_path - path to text file of 
%  N_A - Number of markers on body A
%  N_B - Number of markers on body B
% Returns
%  N_D - Number of markers on body D (not used)
%  N_samps - Number of samples taken in total
%  A - xyz coordinates of A body LED markers in tracker coordinates
%  B - xyz coordinates of B body LED markers in tracker coordinates
%  D - xyz coordinates of other body LED markers in tracker coordinates

    % Read first line
    fid = fopen(file_path);
    varNames = strsplit(fgetl(fid), ' ');
    fclose(fid);

    % Parse file
    N_S = str2double(varNames{1});
    N_samps = str2double(varNames{2});
    N_D = N_S - N_A - N_B;
    M = readmatrix(file_path,'Range',[2 1], 'FileType','text');
    
    A = zeros(N_A, 3, N_samps);
    B = zeros(N_B, 3, N_samps);
    D = zeros(N_D, 3, N_samps);
    
    iD1 = 0;
    for i = 1:N_samps
        iA0 = iD1 + 1;
        iA1 = iA0 + N_A - 1;
        A(:,:,i) = M(iA0:iA1, :);
        
        iB0 = iA1 + 1;
        iB1 = iB0 + N_B - 1;
        B(:,:,i) = M(iB0:iB1, :);
        
        iD0 = iB1 + 1;
        iD1 = iD0 + N_D - 1;
        D(:,:,i) = M(iD0:iD1, :);
    end
end