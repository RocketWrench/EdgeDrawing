classdef Point

    properties(GetAccess = public, SetAccess = private)
        Index(1,1) uint32
        EdgeStrength(1,1) double
        Orientation(1,1) double
        Direction(1,1) ed.enum.Direction = ed.enum.Direction.RIGHT;
    end

    methods
        function this = Point( index, edge, orient, direction )
            if nargin
                this.Index = index;
                this.EdgeStrength = edge;
                this.Orientation = orient;
                this.Direction = direction;
            end
        end
    end
end