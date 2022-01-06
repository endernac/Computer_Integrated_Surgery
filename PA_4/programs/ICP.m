function [F_reg, s, c3, eps_avg_store, sigma_store] = ICP(F_reg, d, triangle_tree, iMax, numRatio, display)
% This function performs the ICP algorithm given some points to match, the
% mesh in a tree structure, a maximum number of iterations, a number of
% error ratios to consider, and a boolean input to determine if the process
% of matching should be printed or not.
% Args:
%   F_reg - 4x4 array, homogeneous transformation as an initial guess for F_reg. 
%   d - Points to match with points in triangle_tree.
%   triangle_tree - Tree of mesh to search through.
%   iMax - maximum number of iterations to search for.
%   numRatio - number of error ratios to consider before exiting.
%   display - boolean variable. If true, print output while searching.
% Output:
%   F_reg - 4x4 array, homogeneous transformation as the solution to ICP
%   s - Matched surface points
%   c - closest points on surface to s.

    
    % Initialize some variables
    [N_samps, ~] = size(d);
    eps_avg_store = [];
    nu_store = [];
    sigma_store = [];
    nu = 5;
    s = homoify((F_reg * homoify(d).').');
    
    
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
        
        % calculate the distance between the observed points and the points on the
        % mesh, and use points that are within threshold
        dist = sum((s - c3).^2, 2);
        % Filter out outlier points since L2 norm is sensitive to outliers. 
        thres = dist < nu + 0.5;
        
        % calculate residuals and error
        E = s(thres) - c3(thres);
        [sigma, ~, eps_avg] = CalcStats(E);
        sigma_store = [sigma_store, sigma];
        eps_avg_store = [eps_avg_store, eps_avg];
        nu = eps_avg * 3;
        nu_store = [nu_store, nu];
        
        % test if the error is NOT changing for multiple iterations, and
        % the most recent error is under some threshold, then quit
        [terminate, ratio] = (TerminationTest(sigma_store, eps_avg_store, "sigma", numRatio));
        
        % print the current iteration info
        if display == true
            fprintf("\nPoint coordinates\n")
            disp(s)
            fprintf("\nCurrent Registration\n")
            disp(F_reg)
            fprintf("\nError\n")
            disp(sigma)
            fprintf("\nRatio\n")
            disp(ratio.')
        end
        
        if (terminate)
            break
        else 
            % update points and registration. Only use "valid" points
            % (through threshold).
            F = Point_Cloud_Registration(s(thres, :), c3(thres, :));
            F_reg = F * F_reg;
            s = homoify(F * homoify(s).');
        end
    end
    if terminate
        disp("Error is not changing. Found registration.")
    else
        disp("Completed max iterations. Exiting registration.")
    end
    

end