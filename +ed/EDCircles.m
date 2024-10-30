classdef EDCircles < handle

    properties(Access = private, Constant = true)
        % Circular arc, circle thresholds
        VERY_SHORT_ARC_ERROR     = 0.40  % Used for very short arcs (>= CANDIDATE_CIRCLE_RATIO1 && < CANDIDATE_CIRCLE_RATIO2)
        SHORT_ARC_ERROR          = 1.00  % Used for short arcs (>= CANDIDATE_CIRCLE_RATIO2 && < HALF_CIRCLE_RATIO)
        HALF_ARC_ERROR           = 1.25  % Used for arcs with length (>=HALF_CIRCLE_RATIO && < FULL_CIRCLE_RATIO)
        LONG_ARC_ERROR           = 1.50  % Used for long arcs (>= FULL_CIRCLE_RATIO)
        
        CANDIDATE_CIRCLE_RATIO1  = 0.25  % 25% -- If only 25% of the circle is detected, it may be a candidate for validation
        CANDIDATE_CIRCLE_RATIO2  = 0.33  % 33% -- If only 33% of the circle is detected, it may be a candidate for validation
        HALF_CIRCLE_RATIO        = 0.50  % 50% -- If 50% of a circle is detected at any point during joins, we immediately make it a candidate
        FULL_CIRCLE_RATIO        = 0.67  % 67% -- If 67% of the circle is detected, we assume that it is fully covered
        
        % Ellipse thresholds
        CANDIDATE_ELLIPSE_RATIO  = 0.50  % 50% -- If 50% of the ellipse is detected, it may be candidate for validation
        ELLIPSE_ERROR            = 1.50  % Used for ellipses. (used to be 1.65 for what reason?)
        
        BOOKSTEIN                = 0     % method1 for ellipse fit
        FPF                      = 1     % method2 for ellipse fit
    end

    methods
        function this = EDCircles()
        end

    end
end