classdef BoundingSphere
    properties
        center = [];
        rho {mustBeNumeric}
        thing = [];
    end
    methods
        function obj = BoundingSphere(c, r)
            if nargin == 2
                obj.center = c;
                obj.rho = r;
            end
        end
    end        
end
