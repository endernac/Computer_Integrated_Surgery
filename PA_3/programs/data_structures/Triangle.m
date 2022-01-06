classdef Triangle
    properties
        corners = zeros(3,3); % Corners of triangle in row format
        center = nan;         % nan to initialize
    end
    methods
        function obj = Triangle(Vertices)
        % Default constructor, takes corners in row format and assigns
        % Args:
        %   Vertices: Corners in row format.
            if nargin == 1
                obj.corners = Vertices;
                % Calculates center on initialization
                obj.center = obj.SortPoint();
            end
        end
        function closest_point = ClosestPointTo(obj, p)
        % Finds the closest point on the triangle to point p.
        % Args:
        %   p: (1 x 3) array that represents the point to search with.
        % Output:
        %   closest_point: The closest point on the triangle to point p.
            [closest_point, ~] = Find_Closest_Point_Triangle(p, obj.corners);
        end
        function v = SortPoint(obj)
        % Finds the SortPoint (mean) on the triangle.
        % Args:
        %   None
        % Output:
        %   v: mean of corners over columns
            if isnan(obj.center)
                % Mean over cols
                v = mean(obj.corners);
            else
                v = obj.center;
            end
        end
        function [LB, UB] = EnlargeBounds(obj, F, LB, UB)
        % Finds the upper and lower bound of the triangle given an initial
        % upper and lower bound and coordinate frame transform
        % Args:
        %   F: Local coordinate frame in homogenous representation
        %   LB: Initial lower bound (1x3) array
        %   UB: Initial upper bound (1x3) array
        % Output:
        %   LB: Lower bound based on self.
        %   UB: Upper bound based on self.
        
            FiC = F \ homoify(obj.corners).'; % should be (4xNcorners)
            for i = 1:3
                LB(1) = min(LB(1), FiC(1, i)); %x
                LB(2) = min(LB(2), FiC(2, i)); %y
                LB(3) = min(LB(3), FiC(3, i)); %z
                UB(1) = max(UB(1), FiC(1, i)); %x
                UB(2) = max(UB(2), FiC(2, i)); %y
                UB(3) = max(UB(3), FiC(3, i)); %z
            end
        end
        function [LB, UB] = BoundingBox(obj, F)
        % Vestigial structure from Thing class (if implemented, which it was not)
            inf = [realmax; realmax; realmax];
            [LB, UB] = obj.EnlargeBounds(F, -inf, inf);
        end
        function inBound = MayBeInBounds(obj, F, LB, UB)
        % Vestigial structure from Thing class (if implemented, which it was not)
            FiC = F \ homoify(obj.corners).'; % should be (4xNcorners)
            inBound = zeros(3,3);
            % Check if every single point's xyz is in bound
            for i = 1:3 % iterate over points
                for j = 1:3 % iterate over xyz
                    inBound(j, i) = (LB(j) < FiC(j,i) && FiC(j,i) < UB(j));
                end
            end
            inBound = all(inBound, 'all'); 
        end
    end
end
