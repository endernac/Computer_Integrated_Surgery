function [terminate, ratio] = TerminationTest(error_store, eps_avg_store, metric, iter)
% This function takes the residuals and calculates the sigma, epsilon max,
% and average epsilon (error).
% Args:
%   error_store - List of all errors so far.
%   metric - Metric used to evaluate termination
%   iter - number of ratios to check to check
% Output:
%   terminate - boolean variable that indicates whether or not the ICP
%   algorithm should terminate. True if it should terminate!
%   ratio - The ratio of error, error_{k} / error_{k-1}. 
    
    [~, END] = size(error_store);
    ratio = zeros(iter, 1);
    % Check if minimum number of iterations have been done. Return if not.
    if END < iter + 1
        terminate = 0;
        return
    end
    
    % Constants for the next part.
    LoadConstants;
    
    % Check if the latest error is less than the designated constants
    if metric == "sigma"
        error_bool = error_store(end) < SIGMA_MIN;
    elseif metric == "eps_max"
        error_bool = error_store(end) < EPS_MAX_MIN;
    elseif metric == "eps_avg"
        error_bool=  error_store(end) < EPS_AVG_MIN;
    end
    
    % Check if last iter errors have not changed.
    
    for i = 1:iter
        ratio(i) = (eps_avg_store(END-i+1) + eps) / (eps_avg_store(END-i) + eps);
    end
    
    % Check if 0.95 < ratio < 1, decimals are for floating point errors.
    gamma_bool = all(GAMMA <= ratio, 'all') & all(ratio <= 1, 'all');
    
    terminate = (gamma_bool & error_bool);
    
end