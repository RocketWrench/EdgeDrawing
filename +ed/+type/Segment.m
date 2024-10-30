classdef Segment

    properties(GetAccess = public, SetAccess = private )
        Id(1,1) string
        Points(:,1) ed.type.Point
    end

    methods
        function this = Segment()
            this.Id = matlab.lang.internal.uuid;
        end
    end

    methods(Access = public)
        function this = add( this, index, edge, orient, direction )
            this.Points(end+1) = ed.type.Point(index,edge,orient,direction);
        end
    end
end