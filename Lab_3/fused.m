clear; close all; clc;
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
half_blk = 1.8;
x_offset = 30;
y_offset = 20;

%% IR Training
for i = 1:9 
    load(sprintf("position_%d.mat", i))
    % positions 1 2 3, x direction, 27 24 20
    short5(i) = mean(short5_IR(data(:,5)));
    short5_std(i) = std(short5_IR(data(:,5)));
    % positions 7 8 9, x direction
    long6(i) = mean(long_IR(data(:,6)));
    long6_std(i) = std(long_IR(data(:,6)));
%     % positions 1 4 7, y direction, 10 13 16
    short7(i) = mean(short7_IR(data(:,7)));
    short7_std(i) = std(short7_IR(data(:,7)));
%     % positions 3 6 9, y direction
    medium8(i) = mean(med_IR(data(:,8)));
    medium8_std(i) = std(med_IR(data(:,8)));
end

std5 = mean(short5_std(1:3));
std7 = mean(long6_std(7:9));
std6 = (short7_std(1)+short7_std(4)+short7_std(7))/3;
std8 = (medium8_std(3)+medium8_std(6)+medium8_std(9))/3;

%% thermocouple models
% Sensor 0
dist_0 = [0; L; 2*L; L; sqrt(2)*L; sqrt(5)*L; 2*L; sqrt(5)*L; sqrt(8)*L];
% thermocouple average voltage output
[v1, v2, v3, v4, v5, v6, v7, v8, v9] = myfun(1,p1,p2,p3,p4,p5,p6,p7,p8,p9);
V_0 = [v1; v2; v3; v4; v5; v6; v7; v8; v9];
temp_0 = (V_0 - 1.25) / 0.005;
therm_0_f = fit(temp_0, dist_0, 'poly1') % temperature to distance function

% Sensor 1
dist_1 = [2*L; L; 0; sqrt(5)*L; sqrt(2)*L; L; sqrt(8)*L; sqrt(5)*L; 2*L];
% thermocouple average voltage output
therm_1_mean = mean(rmoutliers(p1.data(:,2), "mean"));
V_1 = [mean(p1.data(:,2)); mean(p2.data(:,2)); mean(p3.data(:,2)); mean(p4.data(:,2)); mean(p5.data(:,2)); mean(p6.data(:,2)); mean(p7.data(:,2)); mean(p8.data(:,2)); mean(p9.data(:,2))];
temp_1 = (V_1 - 1.25) / 0.005;
therm_1_f = fit(temp_1, dist_1, 'poly1')

% Sensor 2
dist_2 = [2*L; sqrt(5)*L; sqrt(8)*L; L; sqrt(2)*L; sqrt(5)*L; 0; L; 2*L];
% thermocouple average voltage output
V_2 = [mean(p1.data(:,3)); mean(p2.data(:,3)); mean(p3.data(:,3)); mean(p4.data(:,3)); mean(p5.data(:,3)); mean(p6.data(:,3)); mean(p7.data(:,3)); mean(p8.data(:,3)); mean(p9.data(:,3))];
temp_2 = (V_2 - 1.25) / 0.005;
therm_2_f = fit(temp_2, dist_2, 'poly1')

% Sensor 3
dist_3 = [sqrt(8)*L; sqrt(5)*L; 2*L; sqrt(5)*L; sqrt(2)*L; L; 2*L; L; 0];
% thermocouple average voltage output
V_3 = [mean(p1.data(:,4)); mean(p2.data(:,4)); mean(p3.data(:,4)); mean(p4.data(:,4)); mean(p5.data(:,4)); mean(p6.data(:,4)); mean(p7.data(:,4)); mean(p8.data(:,4)); mean(p9.data(:,4))];
temp_3 = (V_3 - 1.25) / 0.005;
therm_3_f = fit(temp_3, dist_3, 'poly1')

%% Thermocouple likelihood function - test 1
x = 0:0.1:10;
y = 0:0.1:10;
[X,Y] = meshgrid(x,y);
% sensor 0
V_0 = rmoutliers(t1.data(:,1),"mean");
temp_0 = (V_0 - 1.25) / 0.005;
therm_0_var = var(therm_0_f(temp_0));
therm_0_dist = therm_0_f(mean(temp_0));

sensor_x = L/2.0;
sensor_y = L/2.0;
distance_to_sensor = sqrt((X-sensor_x).^2 + (Y-sensor_y).^2);

gaussian_xy_0 = gaussmf(distance_to_sensor,[therm_0_var therm_0_dist]);

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

sensor_y = L/2.0;
sensor_x = 5/2 * L;
distance_to_sensor = sqrt((X-sensor_x).^2 + (Y-sensor_y).^2);

gaussian_xy_2 = gaussmf(distance_to_sensor,[therm_2_var therm_2_dist]);

% sensor 3
V_3 = rmoutliers(t1.data(:,4),"mean");
temp_3 = (V_3 - 1.25) / 0.005;
therm_3_f(temp_3)
therm_3_var = var(therm_3_f(temp_3))
therm_3_dist = therm_3_f(mean(temp_3))

sensor_x = 5/2 * L;
sensor_y = 5/2 * L;
distance_to_sensor = sqrt((X-sensor_x).^2 + (Y-sensor_y).^2);

gaussian_xy_3 = gaussmf(distance_to_sensor,[therm_3_var therm_3_dist]);

% IR Sensor
figure();
short5 = mean(rmoutliers(short5_IR(t1.data(:,5)),"mean"));
if short5 < 0 || short5 > 40
    gaussian_short5 = 1;
else
    gaussian_short5 = gaussmf(X,[x_offset-short5-half_blk std5]);
    subplot(2,2,1)
    surf(X,Y,gaussian_short5/sum(gaussian_short5,'all'));
end

long6 = mean(rmoutliers(long_IR(t1.data(:,6)),"mean"));
if long6 < 0 || long6 > 40
    gaussian_long6 = 1;
else
    gaussian_long6 = gaussmf(X,[x_offset-long6-half_blk std6]);
    subplot(2,2,2)
    surf(X,Y,gaussian_long6/sum(gaussian_long6,'all'));
end

short7 = mean(rmoutliers(short5_IR(t1.data(:,7)),"mean"));
if short7 < 0 || short7 > 40
    gaussian_short7 = 1;
else
    gaussian_short7 = gaussmf(Y,[y_offset-short7-half_blk std7]);
    subplot(2,2,3)
    surf(X,Y,gaussian_short7/sum(gaussian_short7,'all'));
end

medium8 = mean(rmoutliers(med_IR(t1.data(:,8)),"mean"));
if medium8 < 0 || medium8 > 40
    gaussian_medium8 = 1;
else
    gaussian_medium8 = gaussmf(Y,[y_offset-medium8-half_blk std8]);
    subplot(2,2,4)
    surf(X,Y,gaussian_medium8/sum(gaussian_medium8,'all'));
end

fused_all_t1 = gaussian_xy_0 .* gaussian_xy_1 .* gaussian_xy_2 .* gaussian_xy_3 .* gaussian_short5 .* gaussian_long6 .* gaussian_short7 .* gaussian_medium8;
figure();
surf(X,Y,fused_all_t1/sum(fused_all_t1,'all'))
xlabel('X'); ylabel('Y'); title('Test Position 1','Interpreter','Latex')

%% Thermocouple likelihood function - test 2
x = 0:0.1:10;
y = 0:0.1:10;
[X,Y] = meshgrid(x,y);
% sensor 0
V_0 = rmoutliers(t2.data(:,1),"mean");
temp_0 = (V_0 - 1.25) / 0.005;
therm_0_var = var(therm_0_f(temp_0));
therm_0_dist = therm_0_f(mean(temp_0));

sensor_x = L/2.0;
sensor_y = L/2.0;
distance_to_sensor = sqrt((X-sensor_x).^2 + (Y-sensor_y).^2);

gaussian_xy_0 = gaussmf(distance_to_sensor,[therm_0_var therm_0_dist]);

% sensor 1
V_1 = rmoutliers(t2.data(:,2),"mean");
temp_1 = (V_1 - 1.25) / 0.005;
therm_1_var = var(therm_1_f(temp_1));
therm_1_dist = therm_1_f(mean(temp_1));

sensor_x = L/2.0;
sensor_y = 5/2 * L;
distance_to_sensor = sqrt((X-sensor_x).^2 + (Y-sensor_y).^2);

gaussian_xy_1 = gaussmf(distance_to_sensor,[therm_1_var therm_1_dist]);

% sensor 2
V_2 = rmoutliers(t2.data(:,3),"mean");
temp_2 = (V_2 - 1.25) / 0.005;
therm_2_var = var(therm_2_f(temp_2));
therm_2_dist = therm_2_f(mean(temp_2));

sensor_y = L/2.0;
sensor_x = 5/2 * L;
distance_to_sensor = sqrt((X-sensor_x).^2 + (Y-sensor_y).^2);

gaussian_xy_2 = gaussmf(distance_to_sensor,[therm_2_var therm_2_dist]);

% sensor 3
V_3 = rmoutliers(t2.data(:,4),"mean");
temp_3 = (V_3 - 1.25) / 0.005;
therm_3_f(temp_3)
therm_3_var = var(therm_3_f(temp_3))
therm_3_dist = therm_3_f(mean(temp_3))

sensor_x = 5/2 * L;
sensor_y = 5/2 * L;
distance_to_sensor = sqrt((X-sensor_x).^2 + (Y-sensor_y).^2);

gaussian_xy_3 = gaussmf(distance_to_sensor,[therm_3_var therm_3_dist]);

% IR Sensor
figure();
short5 = mean(rmoutliers(short5_IR(t2.data(:,5)),"mean"));
if short5 < 0 || short5 > 40
    gaussian_short5 = 1;
else
    gaussian_short5 = gaussmf(X,[x_offset-short5-half_blk std5]);
    subplot(2,2,1)
    surf(X,Y,gaussian_short5/sum(gaussian_short5,'all'));
end

long6 = mean(rmoutliers(long_IR(t2.data(:,6)),"mean"));
if long6 < 0 || long6 > 40
    gaussian_long6 = 1;
else
    gaussian_long6 = gaussmf(X,[x_offset-long6-half_blk std6]);
    subplot(2,2,2)
    surf(X,Y,gaussian_long6/sum(gaussian_long6,'all'));
end

short7 = mean(rmoutliers(short5_IR(t2.data(:,7)),"mean"));
if short7 < 0 || short7 > 40
    gaussian_short7 = 1;
else
    gaussian_short7 = gaussmf(Y,[y_offset-short7-half_blk std7]);
    subplot(2,2,3)
    surf(X,Y,gaussian_short7/sum(gaussian_short7,'all'));
end

medium8 = mean(rmoutliers(med_IR(t2.data(:,8)),"mean"));
if medium8 < 0 || medium8 > 40
    gaussian_medium8 = 1;
else
    gaussian_medium8 = gaussmf(Y,[y_offset-medium8-half_blk std8]);
    subplot(2,2,4)
    surf(X,Y,gaussian_medium8/sum(gaussian_medium8,'all'));
end


fused_all_t2 = gaussian_xy_0 .* gaussian_xy_1 .* gaussian_xy_2 .* gaussian_xy_3 .* gaussian_short5 .* gaussian_long6 .* gaussian_short7 .* gaussian_medium8;
figure();
surf(X,Y,fused_all_t2/sum(fused_all_t2,'all'))
xlabel('X'); ylabel('Y'); title('Test Position 2','Interpreter','Latex')

%% Thermocouple likelihood function - test 3
x = 0:0.1:10;
y = 0:0.1:10;
[X,Y] = meshgrid(x,y);
% sensor 0
V_0 = rmoutliers(t3.data(:,1),"mean");
temp_0 = (V_0 - 1.25) / 0.005;
therm_0_var = var(therm_0_f(temp_0));
therm_0_dist = therm_0_f(mean(temp_0));

sensor_x = L/2.0;
sensor_y = L/2.0;
distance_to_sensor = sqrt((X-sensor_x).^2 + (Y-sensor_y).^2);

gaussian_xy_0 = gaussmf(distance_to_sensor,[therm_0_var therm_0_dist]);

% sensor 1
V_1 = rmoutliers(t3.data(:,2),"mean");
temp_1 = (V_1 - 1.25) / 0.005;
therm_1_var = var(therm_1_f(temp_1));
therm_1_dist = therm_1_f(mean(temp_1));

sensor_x = L/2.0;
sensor_y = 5/2 * L;
distance_to_sensor = sqrt((X-sensor_x).^2 + (Y-sensor_y).^2);

gaussian_xy_1 = gaussmf(distance_to_sensor,[therm_1_var therm_1_dist]);

% sensor 2
V_2 = rmoutliers(t3.data(:,3),"mean");
temp_2 = (V_2 - 1.25) / 0.005;
therm_2_var = var(therm_2_f(temp_2));
therm_2_dist = therm_2_f(mean(temp_2));

sensor_y = L/2.0;
sensor_x = 5/2 * L;
distance_to_sensor = sqrt((X-sensor_x).^2 + (Y-sensor_y).^2);

gaussian_xy_2 = gaussmf(distance_to_sensor,[therm_2_var therm_2_dist]);

% sensor 3
V_3 = rmoutliers(t3.data(:,4),"mean");
temp_3 = (V_3 - 1.25) / 0.005;
therm_3_f(temp_3)
therm_3_var = var(therm_3_f(temp_3))
therm_3_dist = therm_3_f(mean(temp_3))

sensor_x = 5/2 * L;
sensor_y = 5/2 * L;
distance_to_sensor = sqrt((X-sensor_x).^2 + (Y-sensor_y).^2);

gaussian_xy_3 = gaussmf(distance_to_sensor,[therm_3_var therm_3_dist]);

% IR Sensor
figure();
short5 = mean(rmoutliers(short5_IR(t3.data(:,5)),"mean"));
if short5 < 0 || short5 > 40
    gaussian_short5 = 1;
else
    gaussian_short5 = gaussmf(X,[x_offset-short5-half_blk std5]);
    subplot(2,2,1)
    surf(X,Y,gaussian_short5/sum(gaussian_short5,'all'));
end

long6 = mean(rmoutliers(long_IR(t3.data(:,6)),"mean"));
if long6 < 0 || long6 > 40
    gaussian_long6 = 1;
else
    gaussian_long6 = gaussmf(X,[x_offset-long6-half_blk std6]);
    subplot(2,2,2)
    surf(X,Y,gaussian_long6/sum(gaussian_long6,'all'));
end

short7 = mean(rmoutliers(short5_IR(t3.data(:,7)),"mean"));
if short7 < 0 || short7 > 40
    gaussian_short7 = 1;
else
    gaussian_short7 = gaussmf(Y,[y_offset-short7-half_blk std7]);
    subplot(2,2,3)
    surf(X,Y,gaussian_short7/sum(gaussian_short7,'all'));
end

medium8 = mean(rmoutliers(med_IR(t3.data(:,8)),"mean"));
if medium8 < 0 || medium8 > 40
    gaussian_medium8 = 1;
else
    gaussian_medium8 = gaussmf(Y,[y_offset-medium8-half_blk std8]);
    subplot(2,2,4)
    surf(X,Y,gaussian_medium8/sum(gaussian_medium8,'all'));
end


fused_all_t3 = gaussian_xy_0 .* gaussian_xy_1 .* gaussian_xy_2 .* gaussian_xy_3 .* gaussian_short5 .* gaussian_long6 .* gaussian_short7 .* gaussian_medium8;
figure();
surf(X,Y,fused_all_t3/sum(fused_all_t3,'all'))
xlabel('X'); ylabel('Y'); title('Test Position 3','Interpreter','Latex')

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

function dist = short5_IR(x)
    for i = 1:length(x)
        dist(i) = real((39.97 + sqrt(x(i)*-785.96+530.20))/(2*(x(i)+0.2039)));
    end
end

function dist = long_IR(x)
    for i = 1:length(x)
        dist(i) = real((68.4 + sqrt(x(i)*-1750+5442.27))/(2*(x(i)-0.2462)));
    end
end

function dist = short7_IR(x)
    for i = 1:length(x)
        dist(i) = real((10.97 + sqrt(x(i)*-385.96+710.20))/(2*(x(i)+0.5639)));
    end
end

function dist = med_IR(x)
    for i = 1:length(x)
        dist(i) = real((27.28 + sqrt(x(i)*-48.36+520.83))/(2*(x(i)-0.1023)));
    end
end
