load errors.mat

% Arguments to Change
problemNum = '4';
sampleReadingLettersDebug = ['A','B','C','D','E','F'];
sampleReadingLettersUnknown = ['G','H','J','K'];

figure
%% Run main for debug files
fileType = 'Debug';
for i = 1:length(sampleReadingLettersDebug)
    subplot(5,2,i)
    title("PA" + problemNum + '-' + sampleReadingLettersDebug(i) ...
        + '-' + fileType + " Error Plot")
    xlabel("Iteration")
    yyaxis left
    plot(eps_avg_store_debug{i})
    ylabel("Average Epsilon")
    yyaxis right
    plot(sigma_store_debug{i})
    ylabel("Sigma") 
    legend("Average Epsilon", "Sigma")
end

%% Run main for debug files
k = length(sampleReadingLettersDebug);
fileType = 'Unknown';
for i = 1:length(sampleReadingLettersUnknown)
    subplot(5,2,i+k)
    title("PA" + problemNum + '-' + sampleReadingLettersDebug(i) ...
        + '-' + fileType + " Error Plot")
    xlabel("Iteration")
    yyaxis left
    plot(eps_avg_store_debug{i})
    ylabel("Average Epsilon")
    yyaxis right
    plot(sigma_store_debug{i})
    ylabel("Sigma") 
    legend("Average Epsilon", "Sigma")
end