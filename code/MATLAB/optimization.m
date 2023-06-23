%{

    Optimization function to find optimal translation, rotation, and time
    offset parameters.

    Input:
        data1 = an array of cells containing background filtered sensor 1
            point clouds.

        data2 = an array of cells containing background filtered sensor 2
            point clouds.

        lower_bounds = an 8x1 matrix containing lower bounds of the
            optimization parameters, where indices 1 to 3 contain lower
            bounds of translation parameters, indices 4 to 6 contain lower
            bounds of rotation parameters, and indices 7 and 8 contain
            lower bounds of time offset values.

        upper_bounds = an 8x1 matrix containing upper bounds of the
            optimization parameters, where indices 1 to 3 contain upper
            bounds of translation parameters, indices 4 to 6 contain upper
            bounds of rotation parameters, and indices 7 and 8 contain
            upper bounds of time offset values.

    Output:
        x = an 8x1 matrix containig optimal translation, rotation, and time
        offset parameter values.
%}

function [x] = optimization(data1, data2,lower_bounds,upper_bounds)
    x0 = [0;0;0;0;0;0;0;0];
    f = @(x)objectiveFunction(x,data1,data2);
    opts = optimoptions(@fmincon,'Algorithm','sqp');
    problem = createOptimProblem('fmincon','objective',...
        f,'x0',x0,'lb',lower_bounds,'ub',upper_bounds,'options',opts);
    gs = GlobalSearch;
    [x,~] = run(gs,problem);
end