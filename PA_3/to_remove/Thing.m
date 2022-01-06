classdef Thing
    properties
        
    end
    methods
        function obj = CovTreeNode(Ts, nT)
            if nargin == 2
                obj.things = Ts;
                obj.nThings = nT;
            end
            obj.F = ComputeCovFrame();
            [obj.UB, obj.LB] = FindBoundingBox();
            ConstructSubtrees();
        end
        function v = SortPoint(obj)
            
        end
        function closestPoint = ClosestPointTo(point)
            
        end
        function [LB, UB] = EnlargeBounds(F, LB, UB)
            
            
        end
        function [LB, UB] = BoundingBox(F)
            inf = [realmax; realmax; realmax];
            [LB, UB] = EnlargeBounds(F, inf, -inf);
        end
        function inBound = MayBeInBounds(F, LB, UB)
        
        
            
        
    end
end
