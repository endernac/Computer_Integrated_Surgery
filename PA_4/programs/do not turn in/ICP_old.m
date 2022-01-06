function [F_reg, s, c3] = ICP(F_reg, d, triangle_tree, iMax, display)
% This function takes the residuals and calculates the sigma, epsilon max,
% and average epsilon (error).
% Args:
%   F_reg - 4x4 array, homogeneous transformation as an initial guess for F_reg. 
%   d - Points to match with points in triangle_tree.
%   triangle_tree - Tree of mesh to search through.
%   iMax - maximum number of iterations to search for.
%   display - boolean variable. If true, print output while searching.
% Output:
%   terminate - boolean variable that indicates whether or not the ICP
%   algorithm should terminate. True if it should terminate!
%   ratio - The ratio of error, error_{k} / error_{k-1}. 

    % Initialize some variables
    [N_samps, ~] = size(d);
    error_store = [];
    s = homoify(F_reg * homoify(d).');

    % Begin iterations (do iMax iterations max)
    for i = 1:iMax
        if display == true
            fprintf("\nIteration: %d\n", i)
        end

        % Initialize c3
        c3 = zeros(N_samps, 3);

        if display == true
            tic
        end
        % Search tree for point closes to s_k
        for j = 1:N_samps
            bound = realmax;
            closest = [realmax, realmax, realmax];
            [~, c3(j,:)] = triangle_tree.FindClosestPoint(s(j,:), bound, closest);
        end

        if display == true
            toc
        end

        % calculate the error between the observed points and the points on the
        % mesh, and use points that are within threshold
        dist = sum((s - c3).^2, 2);

        % Filter out outlier points since L2 norm is sensitive to outliers. 5
        % is an empirical threshold that seemed to work well.
        thres = dist < 5;
        error = sum(dist(thres)) / sum(thres);
        error_store = [error_store, error];

        % test if the error is NOT changing for multiple iterations, and
        % the most recent error is under some threshold, then quit
        [terminate, ratio] = (TerminationTest(error_store, "sigma", 5));
        
        % print the current iteration info
        if display == true
            fprintf("\nPoint coordinates\n")
            disp(s)
            fprintf("\nCurrent Registration\n")
            disp(F_reg)
            fprintf("\nError\n")
            disp(error)
            fprintf("\nRatio\n")
            disp(ratio.')
        end
        
        if (terminate)
            disp("Error is not changing. Found registration.")
            return
        else 
            % update points and registration. Only use "valid" points
            % (through threshold).
            F = Point_Cloud_Registration(s(thres, :), c3(thres, :));
            F_reg = F * F_reg;
            s = homoify(F * homoify(s).');
        end
    end
    disp("Completed max iterations. Exiting registration.")


end 