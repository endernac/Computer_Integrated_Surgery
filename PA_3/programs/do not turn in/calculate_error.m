%% Generate xlsx file of differences
xlsxname = "Error_Analysis.xlsx";
problemNum = '3';
sampleReadingLettersDebug = ['A','B','C','D','E','F'];
sampleReadingLettersUnknown = ['G','H','J'];

%% Run main for debug files
fileType = 'Debug';
for i = 1:length(sampleReadingLettersDebug)
    calc_error(problemNum, sampleReadingLettersDebug(i), fileType, xlsxname)
end

%% Run main for unknown files
fileType = 'Unknown';
for i = 1:length(sampleReadingLettersUnknown)
    calc_error(problemNum, sampleReadingLettersUnknown(i), fileType, xlsxname)
end

function calc_error(problemNum, sampleReadingLetter, fileType, filename)

    GT_filename = "data/PA" + problemNum + "-" + sampleReadingLetter + "-" + fileType + "-Answer.txt";
    calculated_filename = "output/pa" + problemNum + "-" + sampleReadingLetter + "-Output.txt";

    M_GT = read_Output(GT_filename);
    M_calculated = read_Output(calculated_filename);

    M_diff = abs(M_GT - M_calculated);
    M_diff_mean = mean(M_diff, 1);
    M_diff_std = std(M_diff, 0, 1);
    M_diff = [M_diff; M_diff_mean; M_diff_std];

    d_x = M_diff(:,1);
    d_y = M_diff(:,2);
    d_z = M_diff(:,3);
    c_x = M_diff(:,4);
    c_y = M_diff(:,5);
    c_z = M_diff(:,6);
    mag_diff = M_diff(:,7);
    M_Table = table(d_x, d_y, d_z, c_x, c_y, c_z, mag_diff);
    sheet_name = strcat(fileType, sampleReadingLetter);
    writetable(M_Table,filename,'Sheet',sheet_name,'WriteVariableNames',false);
end