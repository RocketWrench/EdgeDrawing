classdef Anchor

    properties(GetAccess = public, SetAccess = private )
        Id(1,1) string
        Location(1,1) ed.type.Point
        Segments(:,1) ed.type.Segment
    end

    methods
        function this = Anchor( loc )
            arguments
                loc(1,1) ed.type.Point = ed.type.Point()
            end
            this.Location = loc;
            this.Id = matlab.lang.internal.uuid;
        end
    end

    methods(Access = public)
        function this = setPoint( this, index, edge, orient, direction )
            this.Location = ed.type.Point(index,edge,orient,direction);
        end

        function this = add( this, segment )
            this.Segments(end+1) = segment;
        end
    end
end