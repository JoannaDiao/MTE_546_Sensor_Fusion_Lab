clear; close all; clc;
half_blk = 1.8;
x_offset = 30;
y_offset = 20;
x = 0:0.1:10;
y = 0:0.1:10;
[X,Y] = meshgrid(x,y);

%% Training Data
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

gaussian_short5 = gaussmf(X,[x_offset-short5(1)-half_blk short5_std(1)]);
gaussian_short7 = gaussmf(Y,[y_offset-short7(1)-half_blk short7_std(1)]);

gaussian_long6 = gaussmf(X,[x_offset-long6(9)-half_blk long6_std(9)]);
gaussian_medium8 = gaussmf(Y,[y_offset-medium8(9)-half_blk medium8_std(9)]);

gaussian_xy = gaussian_short5 .* gaussian_short7;

% figure();
% surf(X,Y,gaussian_short5/sum(gaussian_short5,'all'));
% surf(X,Y,gaussian_xy/sum(gaussian_xy,'all'))

disp([short5(1) short5(2) short5(3)])
disp([long6(7) long6(8) long6(9)])
disp([short7(1) short7(4) short7(7)])
disp([medium8(3) medium8(6) medium8(9)])

%% Test positions
load("test_3.mat")
figure();
short5 = mean(rmoutliers(short5_IR(data(:,5)),"mean"));
if short5 < 0 || short5 > 40
    gaussian_short5 = 1;
else
    gaussian_short5 = gaussmf(X,[x_offset-short5-half_blk std5]);
    subplot(2,2,1)
    surf(X,Y,gaussian_short5/sum(gaussian_short5,'all'));
end

long6 = mean(rmoutliers(long_IR(data(:,6)),"mean"));
if long6 < 0 || long6 > 40
    gaussian_long6 = 1;
else
    gaussian_long6 = gaussmf(X,[x_offset-long6-half_blk std6]);
    subplot(2,2,2)
    surf(X,Y,gaussian_long6/sum(gaussian_long6,'all'));
end

short7 = mean(rmoutliers(short5_IR(data(:,7)),"mean"));
if short7 < 0 || short7 > 40
    gaussian_short7 = 1;
else
    gaussian_short7 = gaussmf(Y,[y_offset-short7-half_blk std7]);
    subplot(2,2,3)
    surf(X,Y,gaussian_short7/sum(gaussian_short7,'all'));
end

medium8 = mean(rmoutliers(med_IR(data(:,8)),"mean"));
if medium8 < 0 || medium8 > 40
    gaussian_medium8 = 1;
else
    gaussian_medium8 = gaussmf(Y,[y_offset-medium8-half_blk std8]);
    subplot(2,2,4)
    surf(X,Y,gaussian_medium8/sum(gaussian_medium8,'all'));
end

gaussian_fused = gaussian_short5 .* gaussian_long6 .* gaussian_short7 .* gaussian_medium8;

figure();
surf(X,Y,gaussian_fused/sum(gaussian_fused,'all'))


%% IR Sensor Voltage to Distance Functions
function dist = short5_IR(x)
    for i = 1:length(x)
        dist(i) = real((39.97 + sqrt(x(i)*-785.96+530.20))/(2*(x(i)+0.2039)));
    end
end

function dist = long_IR(x)
    for i = 1:length(x)
        dist(i) = real((65.4 + sqrt(x(i)*-1750+5442.27))/(2*(x(i)-0.2462)));
    end
end

function dist = short7_IR(x)
    for i = 1:length(x)
        dist(i) = real((8.97 + sqrt(x(i)*-385.96+710.20))/(2*(x(i)+0.5639)));
    end
end

function dist = med_IR(x)
    for i = 1:length(x)
        dist(i) = real((27.28 + sqrt(x(i)*-48.36+520.83))/(2*(x(i)-0.1023)));
    end
end

