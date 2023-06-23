clear;
%load the data
load("DemoData.mat");

% set lower bounds of the optimization variables
lower_bounds = [0; 0; 0; 0; 0; 0; 1; 1];

% set upper bounds of the optimization variables
upper_bounds = [30; 30; 10; 360; 360; 360; 1; 1];

x = optimization(sensor1Filtered, sensor2Filtered,lower_bounds,upper_bounds);


% show fused data

translation = [x(1) x(2) x(3)];
angles = [x(4) x(5) x(6)];
t1 = x(7);
t2 = x(8);
tform = rigidtform3d(angles,translation);
ptCloudTformed = pctransform(data2{t2,1},tform);
pcshow(data1{t1,1}.Location,'b','BackgroundColor','w');
hold on;
pcshow(ptCloudTformed.Location,'b','BackgroundColor','w');
axis on;