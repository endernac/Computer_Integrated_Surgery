function [error, mu, stddev] = calc_v_error(output_filename, gt_filename)


    % Read first line of output
    fid = fopen(output_filename);
    varNames = strsplit(fgetl(fid), ', ');
    fclose(fid);

    % Parse file
    N_D = str2double(varNames{1});
    v_output = readmatrix(output_filename)
    
    % Read first line of ground truth
    fid = fopen(gt_filename);
    varNames = strsplit(fgetl(fid), ', ');
    fclose(fid);

    % Parse file
    N_D = str2double(varNames{1});
    v_GT = readmatrix(gt_filename);

    
   error = abs(v_output - v_GT)
   mu = mean(error)
   stddev = std(error)
end