classdef EdgeDrawing < handle

    properties(Access = public, Dependent = true)
        CornerThreshold(1,1) double {mustBePositive}
        EdgeThreshold(1,1) double {mustBePositive}
        % ScanInterval(1,1) double {mustBePositive}
    end

    properties(Access = private, Constant = true)
        
    end

    properties(Access = private)
        Detector(1,1) PhaseCongruency

        CornerThreshold_(1,1) double {mustBePositive} = 0.3;
        EdgeThreshold_(1,1) double {mustBePositive} = 0.3;
        ScanInterval_(1,1) double {mustBePositive} = 1;

        CurrentImage(:,:,:) {mustBeNumericOrLogical}

        HasBeenInitialized(1,1) logical = false;
    end

    methods
        function this = EdgeDrawing( I, cornerThreshold, edgeThreshold, scanInterval, detectorOptions )
            arguments
                I {validateImageOrEmpty(I)} = [];
                cornerThreshold(1,1) double {mustBePositive} = 0.3;
                edgeThreshold(1,1) double {mustBePositive} = 0.3;
                scanInterval(1,1) double {mustBePositive} = 10;
                detectorOptions.?PhaseCongruency
            end

            this.CornerThreshold_ = cornerThreshold;
            this.EdgeThreshold_ = edgeThreshold;
            this.ScanInterval_ = scanInterval;

            this.Detector = PhaseCongruency();
            % set(this.Detector,detectorOptions);

            if ~isempty(I)
                this.CurrentImage = I;
                this.detect(I);
            end
        end
    end

    methods(Access = public)
        function detect( this, I )
            if ~this.HasBeenInitialized
                this.initialize(I);
            end

            segments = ed.segmentor(this.Detector.CornerStrength,0.28,...
                this.Detector.EdgeStrength,0.10,this.Detector.Orientation);

        end
    end

    methods

        function value = get.CornerThreshold( this )
            value = this.CornerThreshold_;
        end

        function set.CornerThreshold( this, value )
            validateattributes(value,{'numeric'},{'scalar','>=',0,'<=',1})
            this.CornerThreshold_ = value;
        end

        function value = get.EdgeThreshold( this )
            value = this.EdgeThreshold_;
        end

        function set.EdgeThreshold( this, value )
            validateattributes(value,{'numeric'},{'scalar','>=',0,'<=',1})
            this.EdgeThreshold_ = value;
        end        

    end

    methods(Access = private)
        function initialize( this, I )
            this.Detector.detect(I);
            this.HasBeenInitialized = true;
        end
    end
end

function tf = validateImageOrEmpty( I )
    tf = true;
    if ~isempty(I)
        allowedImageTypes = {'uint8', 'uint16', 'double', 'logical', 'single', 'int16'};
        validateattributes(I,allowedImageTypes,{'nonempty',...
            'nonsparse','real'},mfilename,'A',1);
        N = ndims(I);
        if (isvector(I) || N > 3)
            error(message('images:imfindcircles:invalidInputImage'));
        elseif (N == 3)
            if (size(I,3) ~= 3)
                error(message('images:imfindcircles:invalidImageFormat'));
            end
        end
        tf = true;        
    end
end