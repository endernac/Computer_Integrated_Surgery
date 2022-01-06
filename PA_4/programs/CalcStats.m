function [sigma, eps_max, eps_avg] = CalcStats(E)
% This function takes the residuals and calculates the sigma, epsilon max,
% and average epsilon (error).
% Args:
%   E - (N_points x dim) array of residuals.
% Output:
%   sigma - std deviation of error.
%   eps_max - Maximum magnitude of error
%   eps_avg - Average error.

    [N_points, ~] = size(E);
    % element wise dot product, think as e_k . e_k
    dp = E.' .* E.'; % N_points x 1 vector

    % Following formulas on the slides
    sigma = sqrt(sum(dp)) / N_points;
    [~, iMax] = max(dp);
    eps_max = E(iMax);
    eps_avg = sum(sqrt(dp)) / N_points;

end 