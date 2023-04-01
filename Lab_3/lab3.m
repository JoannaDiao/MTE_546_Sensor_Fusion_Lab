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
% Sensor 0
dist_0 = [0; L; 2*L; L; sqrt(2)*L; sqrt(5)*L; 2*L; sqrt(5)*L; sqrt(8)*L];
% thermocouple average voltage output
V_0 = [mean(p1.data(:,1)); mean(p2.data(:,1)); mean(p3.data(:,1)); mean(p4.data(:,1)); mean(p5.data(:,1)); mean(p6.data(:,1)); mean(p7.data(:,1)); mean(p8.data(:,1)); mean(p9.data(:,1))];
temp_0 = (V_0 - 1.25) / 0.005;
therm_0_f = fit(dist_0, temp_0, 'poly2')
figure(1);
plot(therm_0_f,dist_0,temp_0);
title("sensor 0");

% Sensor 1
dist_1 = [2*L; L; 0; sqrt(5)*L; sqrt(2)*L; L; sqrt(8)*L; sqrt(5)*L; 2*L];
% thermocouple average voltage output
V_1 = [mean(p1.data(:,2)); mean(p2.data(:,2)); mean(p3.data(:,2)); mean(p4.data(:,2)); mean(p5.data(:,2)); mean(p6.data(:,2)); mean(p7.data(:,2)); mean(p8.data(:,2)); mean(p9.data(:,2))];
temp_1 = (V_0 - 1.25) / 0.005;
therm_1_f = fit(dist_1, temp_1, 'poly1')
figure(2);
plot(therm_1_f,dist_1,temp_1);
title("sensor 1");

% Sensor 2
dist_2 = [2*L; sqrt(5)*L; sqrt(8)*L; L; sqrt(2)*L; sqrt(5)*L; 0; L; 2*L];
% thermocouple average voltage output
V_2 = [mean(p1.data(:,3)); mean(p2.data(:,3)); mean(p3.data(:,3)); mean(p4.data(:,3)); mean(p5.data(:,3)); mean(p6.data(:,3)); mean(p7.data(:,3)); mean(p8.data(:,3)); mean(p9.data(:,3))];
temp_2 = (V_0 - 1.25) / 0.005;
therm_2_f = fit(dist_2, temp_2, 'poly2')
figure(3);
plot(therm_2_f,dist_2,temp_2);
title("sensor 2");

% Sensor 3
dist_3 = [sqrt(8)*L; sqrt(5)*L; 2*L; sqrt(5)*L; sqrt(2)*L; L; 2*L; L; 0];
% thermocouple average voltage output
V_3 = [mean(p1.data(:,4)); mean(p2.data(:,4)); mean(p3.data(:,4)); mean(p4.data(:,4)); mean(p5.data(:,4)); mean(p6.data(:,4)); mean(p7.data(:,4)); mean(p8.data(:,4)); mean(p9.data(:,4))];
temp_3 = (V_0 - 1.25) / 0.005;
therm_3_f = fit(dist_3, temp_3, 'poly2')
figure(3);
plot(therm_3_f,dist_3,temp_3);
title("sensor 3");