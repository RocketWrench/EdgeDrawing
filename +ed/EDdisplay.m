function EDdisplay( I, anchors )
    
    [n,m,~] = size(I);
    imshow(I);

    anchorLocs = [];
    locs = [];
    for itr = 1:numel(anchors)
        anchorLocs = [anchorLocs;anchors(itr).Location.Index];
        for itn = 1:numel(anchors(itr).Segments)
            locs = [locs;[anchors(itr).Segments(itn).Points.Index]'];
        end
    end

    [r,c] = ind2sub([n,m],anchorLocs);    

    hold on
    plot(c,r,'og');

    [r,c] = ind2sub([n,m],locs);    

    hold on
    plot(c,r,'or');
end