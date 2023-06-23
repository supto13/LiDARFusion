%{
    Objection function for the optimization problem

    Input:
        x = optimization variables, an 8x1 matrix where indices 1 to 3
            contain translation parameters, indices 4 to 6 contain
            rotation parameters, and indices 7 and 8 contain time offset
            values.

        data1 = an array of cells containing background filtered sensor 1
            point clouds.

        data2 = an array of cells containing background filtered sensor 2
            point clouds.

    Output:
        y = nearest neighbor distance between point cloud frame
            data1{x(7),1} and data2{x(8),1}.
        

%}
function y = objectiveFunction(x,data1,data2)
    translation = [x(1) x(2) x(3)];
    angles = [x(4) x(5) x(6)];
    tform = rigidtform3d(angles,translation);
    t1 = int32(x(7));
    t2 = int32(x(8));
    ptCloudTformed = pctransform(data2{t2,1},tform);
    loc = reshape(ptCloudTformed.Location, [], 3);
    m = length(loc);
    y2 = 0;
    for i = 1:m
        if isnan(loc(i,1))
            continue;
        end
        [~, dist] = findNearestNeighbors(data1{t1,1},loc(i,:),1);
        y2 = y2+dist;
    end
    loc = reshape(data1{t1,1}.Location, [], 3);
    n = length(loc);
    y1 = 0;
    for i = 1:n
        if isnan(loc(i,1))
            continue;
        end
        [~, dist] = findNearestNeighbors(ptCloudTformed,loc(i,:),1);
        y1 = y1+dist;
    end
    y = double(y1)+double(y2)*(n/m);
end