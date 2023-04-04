clear;

p1 = load('position_1.mat');
p2 = load('position_2.mat');
p3 = load('position_3.mat');
p4 = load('position_4.mat');
p5 = load('position_5.mat');
p6 = load('position_6.mat');
p7 = load('position_7.mat');
p8 = load('position_8.mat');
p9 = load('position_9.mat');
t1 = load('test_1.mat');
t2 = load('test_2.mat');
t3 = load('test_3.mat');

L = 10.0/3.0;
%% thermocouple models
% Sensor 0
dist_0 = [0; L; 2*L; L; sqrt(2)*L; sqrt(5)*L; 2*L; sqrt(5)*L; sqrt(8)*L];
% thermocouple average voltage output
[v1, v2, v3, v4, v5, v6, v7, v8, v9] = myfun(1,p1,p2,p3,p4,p5,p6,p7,p8,p9);
V_0 = [v1; v2; v3; v4; v5; v6; v7; v8; v9];
temp_0 = (V_0 - 1.25) / 0.005;
therm_0_f = fit(temp_0, dist_0, 'poly1') % temperature to distance function
figure(1);
plot(therm_0_f,temp_0,dist_0);
title("sensor 0");

% Sensor 1
dist_1 = [2*L; L; 0; sqrt(5)*L; sqrt(2)*L; L; sqrt(8)*L; sqrt(5)*L; 2*L];
% thermocouple average voltage output
therm_1_mean = mean(rmoutliers(p1.data(:,2), "mean"));
V_1 = [mean(p1.data(:,2)); mean(p2.data(:,2)); mean(p3.data(:,2)); mean(p4.data(:,2)); mean(p5.data(:,2)); mean(p6.data(:,2)); mean(p7.data(:,2)); mean(p8.data(:,2)); mean(p9.data(:,2))];
temp_1 = (V_0 - 1.25) / 0.005;
therm_1_f = fit(temp_1, dist_1, 'poly1')
figure(2);
plot(therm_1_f,temp_1,dist_1);
title("sensor 1");

% Sensor 2
dist_2 = [2*L; sqrt(5)*L; sqrt(8)*L; L; sqrt(2)*L; sqrt(5)*L; 0; L; 2*L];
% thermocouple average voltage output
V_2 = [mean(p1.data(:,3)); mean(p2.data(:,3)); mean(p3.data(:,3)); mean(p4.data(:,3)); mean(p5.data(:,3)); mean(p6.data(:,3)); mean(p7.data(:,3)); mean(p8.data(:,3)); mean(p9.data(:,3))];
temp_2 = (V_0 - 1.25) / 0.005;
therm_2_f = fit(temp_2, dist_2, 'poly1')
figure(3);
plot(therm_2_f,temp_2,dist_2);
title("sensor 2");

% Sensor 3
dist_3 = [sqrt(8)*L; sqrt(5)*L; 2*L; sqrt(5)*L; sqrt(2)*L; L; 2*L; L; 0];
% thermocouple average voltage output
V_3 = [mean(p1.data(:,4)); mean(p2.data(:,4)); mean(p3.data(:,4)); mean(p4.data(:,4)); mean(p5.data(:,4)); mean(p6.data(:,4)); mean(p7.data(:,4)); mean(p8.data(:,4)); mean(p9.data(:,4))];
temp_3 = (V_0 - 1.25) / 0.005;
therm_3_f = fit(dist_3, temp_3, 'poly1')
figure(4);
plot(therm_3_f,dist_3,temp_3);
title("sensor 3");

%% Thermocouple likelihood function 
% test 1
% sensor 0
V_0 = rmoutliers(t1.data(:,1),"mean");
temp_0 = (V_0 - 1.25) / 0.005;
therm_0_var = var(therm_0_f(temp_0));
therm_0_dist = therm_0_f(mean(temp_0));

x = 0:0.1:10;
y = 0:0.1:10;

[X,Y] = meshgrid(x,y);

sensor_x = L/2.0;
sensor_y = L/2.0;
distance_to_sensor = sqrt((X-sensor_x).^2 + (Y-sensor_y).^2);

gaussian_xy_0 = gaussmf(distance_to_sensor,[therm_0_var therm_0_dist]);

surf(X,Y,gaussian_xy_0/sum(gaussian_xy_0,'all'))
xlabel('X'); ylabel('Y'); title('sensor pos=(L/2, L/2), distance$=5$','Interpreter','Latex')

% sensor 1
V_1 = rmoutliers(t1.data(:,2),"mean");
temp_1 = (V_1 - 1.25) / 0.005;
therm_1_var = var(therm_1_f(temp_1));
therm_1_dist = therm_1_f(mean(temp_1));

sensor_x = L/2.0;
sensor_y = 5/2 * L;
distance_to_sensor = sqrt((X-sensor_x).^2 + (Y-sensor_y).^2);

gaussian_xy_1 = gaussmf(distance_to_sensor,[therm_1_var therm_1_dist]);

% sensor 2
V_2 = rmoutliers(t1.data(:,3),"mean");
temp_2 = (V_2 - 1.25) / 0.005;
therm_2_var = var(therm_2_f(temp_2));
therm_2_dist = therm_2_f(mean(temp_2));

sensor_x = 5/2 * L;
sensor_y = 5/2 * L;
distance_to_sensor = sqrt((X-sensor_x).^2 + (Y-sensor_y).^2);

gaussian_xy_2 = gaussmf(distance_to_sensor,[therm_2_var therm_2_dist]);



%% functions
function [v1, v2, v3, v4, v5, v6, v7, v8, v9] = myfun(sensor_num,p1,p2,p3,p4,p5,p6,p7,p8,p9)
    v1 = mean(rmoutliers(p1.data(:,sensor_num), "mean"));
    v2 = mean(rmoutliers(p2.data(:,sensor_num), "mean"));
    v3 = mean(rmoutliers(p3.data(:,sensor_num), "mean"));
    v4 = mean(rmoutliers(p4.data(:,sensor_num), "mean"));
    v5 = mean(rmoutliers(p5.data(:,sensor_num), "mean"));
    v6 = mean(rmoutliers(p6.data(:,sensor_num), "mean"));
    v7 = mean(rmoutliers(p7.data(:,sensor_num), "mean"));
    v8 = mean(rmoutliers(p8.data(:,sensor_num), "mean"));
    v9 = mean(rmoutliers(p9.data(:,sensor_num), "mean"));
end