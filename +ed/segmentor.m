function anchors = segmentor( corner, cth, edge, eth, orient )
import ed.type.*
import ed.enum.Direction

    [rows,cols] = size(corner);
    npixels = rows*cols;

    [corner_mag,corner_idx] = sort(corner(:),'descend');
    corner_idx(corner_mag < cth) = [];

    ncorners = numel(corner_idx);

    anchors(ncorners,1) = Anchor();

    available_mask = true(npixels,1);
    available_mask(corner_idx) = false;

    if ~isempty(corner_idx)
        for itr = 1:ncorners   

            ind = corner_idx(itr);
            loc = Point(ind,edge(ind),orient(ind),Direction.ANCHOR);
            anchor = Anchor(loc);  

            ind8 = neighbhors(ind);
            if isempty(ind8); continue; end
            available = available_mask(ind8);
            if sum(available) == 0; continue; end
            [e8,k] = sort(edge(ind8(available)),'descend');
            o8 = orient(ind8(k));
            ind8 = ind8(k);

            for itn = 1:numel(e8)
                if e8(itn) >= eth
                    ind = ind8(itn);
                    seg = Segment();
                    seg = add(seg,ind,e8(itn),o8(itn),Direction.ANCHOR);
                    orientation = o8(itn);
                    [fcn,dir] = getDirectionFunction(orientation);
                    doLoop = true;
                    while doLoop
                        idx = fcn(ind);
                        doLoop = ~isempty(idx) & available_mask(idx);
                        if doLoop
                            available_mask(idx) = false;
                            orientation = orient(idx);
                            seg = add(seg,idx,edge(idx),orientation,dir);
                            [fcn,dir] = getDirectionFunction(orientation);
                            ind = idx;
                        end
                    end
                    if numel(seg.Points) > 1
                        anchor = add(anchor,seg);
                    end
                end
            end

            anchors(itr) = anchor;
            
            % seg = add(seg,ind,edge(ind),orient(ind),Direction.ANCHOR);
            % dir = Direction.RIGHT;
            % doLoop = true;
            % while doLoop
            %     idx = goRight(ind);
            %     doLoop = ~isempty(idx);
            %     if doLoop
            %         seg = add(seg,idx,edge(idx),orient(idx),dir);
            %         ind = idx;
            %     end
            % end
            % 
            % ind = corner_idx(itr);
            % dir = Direction.LEFT;
            % doLoop = true;
            % while doLoop
            %     idx = goLeft(ind);
            %     doLoop = ~isempty(idx);
            %     if doLoop
            %         seg = add(seg,idx,edge(idx),orient(idx),dir);
            %         ind = idx;
            %     end
            % end
            % 
            % ind = corner_idx(itr);
            % dir = Direction.UP;
            % doLoop = true;
            % while doLoop
            %     idx = goUp(ind);
            %     doLoop = ~isempty(idx);
            %     if doLoop
            %         seg = add(seg,idx,edge(idx),orient(idx),dir);
            %         ind = idx;
            %     end
            % end
            % 
            % ind = corner_idx(itr);
            % dir = Direction.DOWN;
            % doLoop = true;
            % while doLoop
            %     idx = goDown(ind);
            %     doLoop = ~isempty(idx);
            %     if doLoop
            %         seg = add(seg,idx,edge(idx),orient(idx),dir);
            %         ind = idx;
            %     end
            % end
            % 
            % anchors(itr) = seg;
        end
    else

    end

    function to = goLeft( from )
        inds = [];
        state = border(from);
        if ~any(state)
            inds = from + (rows * [-1,-1,-1] + [-1,0,1]);
        elseif state(1)
            to = [];
            return
        elseif state(3)
            inds = from + (rows * [-1,-1] + [0,1]);
        elseif state(4)
            inds = from + (rows * [-1,-1] + [-1,0]);
        end
        to = cleanup(inds);     
    end
    
    function to = goRight( from )
        inds = [];
        state = border(from);
        if ~any(state)
            inds = from + (rows * [1,1,1] + [-1,0,1]);
        elseif state(2)
            to = [];
            return
        % elseif state(5) || state(8)

        elseif state(3)
            inds = from + (rows * [1,1] + [0,1]);
        elseif state(4)
            inds = from + (rows * [1,1] + [-1,0]);
        end            
        to = cleanup(inds);       
    end
    
    function to = goUp( from )
        inds = [];
        state = border(from);
        if ~any(state)        
            inds = from + (rows * [-1,0,1] + [-1,-1,-1]);
        elseif state(3)
            to = [];
            return
        elseif state(1)
            inds = from + (rows * [0,1] + [-1,-1]);
        elseif state(2)
            inds = from + (rows * [-1,0] + [-1,-1]);
        end             
        to = cleanup(inds);        
    end

    function to = goDown( from )
        inds = [];
        state = border(from);
        if ~any(state)          
            inds = from + (rows * [-1,0,1] + [1,1,1]);
        elseif state(4)
            to = [];
            return
        elseif state(1)
            inds = from + (rows * [0,1] + [1,1]);
        elseif state(2)
            inds = from + (rows * [-1,0] + [1,1]);
        end            
        to = cleanup(inds); 
    end

    function inds = neighbhors( ind )
        inds = [];
        state = border(ind);
        if ~any(state)
            inds = ind + (rows * [0,1,1,1,0,-1,-1,-1] + [-1,-1,0,1,1,1,0,-1]);
        end

    end

    function out = cleanup( in )
        out = [];
        in(in < 1 ) = [];
        in(in > npixels ) = [];
        if isempty(in); return; end 
        edge_values = edge(in);
        mask = edge_values < eth;
        edge_values(mask) = [];
        in(mask) = [];
        if isempty(edge_values); out = [];return;end
        [~,k] = max(edge_values);
        out = in(k);
    end

    function state = border( in )
        top = 1:rows:npixels-rows + 1;
        bot = rows:rows:npixels;
        state = [in <= rows,...                 % left border
                 in >= (npixels-rows + 1),...   % right border
                 any(in == top),...             % top boder
                 any(in == bot),...             % bottom boder
                 in == top(1),...               % tl corner
                 in == top(end),...             % tr corner
                 in == bot(end),...             % br corner
                 in == bot(1)];                 % bl corner
    end

    function [fcn,dir] = getDirectionFunction( orientation )
        s = sign(orientation);
        v = floor(abs(orientation)/60);
        switch v
            case 0
                fcn = @(x) goLeft(x);
                dir = Direction.LEFT;
            case 1
                if s < 0
                    fcn = @(x) goUp(x);
                    dir = Direction.UP;
                else
                    fcn = @(x) goDown(x);
                    dir = Direction.DOWN;
                end
            case {2,3}
                fcn = @(x) goRight(x);
                dir = Direction.RIGHT;
        end
    end

end

 % East         M
 % Southeast    M + 1
 % South        1
 % Southwest   -M + 1
 % West        -M
 % Northwest   -M - 1
 % North       -1
 % Northeast    M - 1