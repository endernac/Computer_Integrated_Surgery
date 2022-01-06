classdef CovTreeNode
    properties (Access = private)
        F = zeros(4,4);    % Local coordinate frame
        UB = zeros(3,1);   % upper bound
        LB = zeros(3,1);   % lower bound
        haveSubtrees = 0;  % boolean indicating if leaf node
        nThings = 0;       % number of items in tree
        LeftSubtree = [];  % left child tree
        RightSubtree = []; % right child tree
        things = [];       % all things in children
        minCount = 10;     % minimum number of things in a tree
        minDiag = 1;       % minimum diagonal of bounding box
    end
    methods
        function obj = CovTreeNode(Ts, nT)
        % This is the default constructor.
        % Args: 
        %   nT: integer, number of Things in Ts.  
        %   Ts: A (nT x 1) cell array of things. 
        
            if nargin == 2
                % Assign things and nThings
                obj.things = Ts;
                obj.nThings = nT;
                % Compute local coordinate frame
                obj.F = obj.ComputeCovFrame(obj.things, obj.nThings);
                % Find local bounding box
                [obj.LB, obj.UB] = obj.FindBoundingBox(obj.F, obj.things, obj.nThings);
                % Construct subtrees
                obj = obj.ConstructSubtrees();
            end
        end
        function F = ComputeCovFrame(obj, Ts, nT)
        % This function computes the local coordinate frame given a cell
        % array of things and the number of things.
        % Args: 
        %   Ts: A (N_things x 1) cell array of things. 
        %   nT: integer of N_things.  
        % Output:
        %   F: Local coordinate frame in homogenous representation
         
            % Get sort points from the Things
            [points, nP] = obj.ExtractPoints(Ts, nT);
            % Get 
            F = obj.ComputeCovFramePoints(points, nP);
        end
        function F = ComputeCovFramePoints(obj, Ps, nP)
        % This function computes the local coordinate frame
        % Args: 
        %   Ts: A (N_things x 1) cell array of things. 
        %   nT: integer of N_things.  
        % Output:
        %   F: Local coordinate frame in homogenous representation
        
            % Calculate centroid, sum operates over col
            C = 1 / nP * sum(Ps, 1);
            % Make sure C goes over correct dimension
            [~, c] = size(C);
            assert(c == 3)
            % Calculate residuals
            U = Ps - C;
            % Calculate outer product
            A = U.' * U;
            % Find R
            R = obj.CorrespondingRotationMatrix(A);
            % Return homo. transformation
            F = SE3(R, C.');
        end
        function obj = ConstructSubtrees(obj)
        % This function constructs subtrees of the tree (recursively). 
        % Args: 
        %   None
        
            % If there are fewer than the minimum number of things OR the
            % all the things are closely clustered, don't make subtrees
            if (obj.nThings <= obj.minCount || norm(obj.UB - obj.LB) <= obj.minDiag)
                % if leaf, set subtrees = 0
                obj.haveSubtrees = 0;
                return
            end
            % Otherwise, make subtrees
            obj.haveSubtrees = 1;
            % Sort and split the left and right tree
            [left_tree, right_tree] = obj.SplitSort(obj.F, obj.things, obj.nThings);
            % add to object
            obj.LeftSubtree = CovTreeNode(left_tree, length(left_tree));
            obj.RightSubtree = CovTreeNode(right_tree, length(right_tree));
        end
        function [bound, closest] = FindClosestPoint(obj, v, bound, closest)
        % This function finds the closest point on the mesh to a given
        % point, v.
        % This function constructs subtrees of the tree (recursively). 
        % Args: 
        %   v - This is a (1 x 3) vector represention the point to
        %   search with. 
        %   bound - This is the closest distance found so far in the
        %   search. It is used to decide which subtrees to traverse
        %   through.
        %   closest - This is the closest point found so far,
        %   associated with bound.
            
            % Convert v to local coordinate system
            vLocal = homoify(obj.F \ homoify(v).');
            
            % check if point is within bound
            if (vLocal(1) > obj.UB(1) + bound)
                return
            end
            if (vLocal(1) < obj.LB(1) - bound)
                return
            end
            if (vLocal(2) > obj.UB(2) + bound)
                return
            end
            if (vLocal(2) < obj.LB(2) - bound)
                return
            end
            if (vLocal(3) > obj.UB(3) + bound)
                return
            end
            if (vLocal(3) < obj.LB(3) - bound)
                return
            end
            
            % Check subtrees if there are any, again with recursive call
            if obj.haveSubtrees 
                [bound, closest] = obj.LeftSubtree.FindClosestPoint(v, bound, closest);
                [bound, closest] = obj.RightSubtree.FindClosestPoint(v, bound, closest);
            else
            % If at leaves, then search through them all to find the
            % closest points and update the bound.
                for i = 1:obj.nThings
                    [bound, closest] = obj.UpdateClosest(obj.things{i}, v, bound, closest);
                end
            end
        end
    end
	methods(Static)
        function [LB, UB] = FindBoundingBox(F, Ts, nT)
        % This function finds the bounding box of a tree given a cell array
        % of trees, the number of trees, and its local coordinate frame
        % Args: 
        %   F: Local coordinate frame in homogenous representation
        %   Ts: A (N_things x 1) cell array of things. 
        %   nT: integer of N_things.  
        % Output:
        %   LB - Lower bound (1x3) array
        %   UB - Upper bound (1x3) array
        
            % Initialize UB and LB by mapping first Thing into local
            % coordinate frame
            UB = homoify(F \ homoify(Ts{1}.SortPoint()).');
            LB = UB;
            
            % See if any of the other points have a lower or higher bound
            for k = 1:nT
                [LB, UB] = Ts{k}.EnlargeBounds(F, LB, UB);
            end
        end
        function [Ps, nP] = ExtractPoints(Ts, nT)
        % This function simply returns an array of all the corners in Ts.
        % Args:
        %   nT: integer of N_things.
        %   Ts: A (nT x 1) cell array of things. 
        % Output:
        %   nP: integer of number of points (corners) 
        %   Ps: A (nP x 1) array of corners
        
            % Get all sort points in Ts
            Ps = [];
            for i = 1:nT
                Ps = [Ps; Ts{i}.corners];
            end
            nP = length(Ps);
        end
        function R = CorrespondingRotationMatrix(A)
        % This function calculates the rotation matrix of a given set of 
        % points for the covariance tree.
        % Args:
        %   nT: integer of N_things.
        %   Ts: A (nT x 1) cell array of things. 
        % Output:
        %   R: Rotation matrix for local coordinate frame
        
            [Q, lambda] = eig(A); % columns of Q are eigen vectors
            lambda = diag(lambda); % extract eig values from diagonal matrix
            % largest eig. vector is vector corresponding to largest eig. value
            [~, iMax] = max(lambda);
            Rx = Q(:,iMax);
            % Assign last two eigen vectors for Ry, Rz
            idxs = [1, 2, 3];
            idxs(iMax) = []; % depopulate iMax
            % Construct rotation matrix
            Ry = Q(:, idxs(1));
            Rz = Q(:, idxs(2));
            R = [Rx, Ry, Rz].';
        end
        function [left_tree, right_tree] = SplitSort(F, Ts, nT)
        % This function simply returns an array of all the corners in Ts.
        % Args: 
        %   F: Local coordinate frame in homogenous representation
        %   Ts: A (N_things x 1) cell array of things. 
        %   nT: integer of N_things.  
        % Output:
        %   left_tree - Left subtree.
        %   right_tree - Right subtree.
        
            % initialize left and right tree
            left_tree = [];
            right_tree = [];
            % Run through all the points and sort them
            for k = 1:nT
                temp = (F \ homoify(Ts{k}.SortPoint()).');
                if temp(1) < 0
                    left_tree = [left_tree; Ts(k)];
                else
                    right_tree = [right_tree; Ts(k)];
                end
            end
            % return sorted trees
        end
        function [bound, closest] = UpdateClosest(T, v, bound, closest)
        % This point updates the closest point and distance given a prior,
        % the current point, and the current triangle.
        % Args: 
        %   T: Object of type Thing (triangle)
        %   v: closest point in global coordinates
        %   bound: closest distance to point v found so far
        %   closest: closest point to point v found so far
        % Output:
        %   LB - Lower bound (1x3) array
        %   UB - Upper bound (1x3) array
        
            % Find closest point to triangle T
            cp = T.ClosestPointTo(v);
            % Calculate distance from v
            dist = norm(cp - v);
            % If distance is smaller, then update distance and point
            if (dist < bound)
                bound = dist;
                closest = cp;
            end
        end
    end
end
