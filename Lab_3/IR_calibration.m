clear; close all; clc;

for i = 1:9 
    load(sprintf("position_%d.mat", i))
    short5(i) = mean(short_IR(data(:,5)));
    long6(i) = mean(long_IR(data(:,6)));
    short7(i) = mean(short_IR(data(:,7)));
    medium8(i) = mean(med_IR(data(:,8)));
end

% IR Sensor Voltage to Distance Functions
function dist = short_IR(x)
    for i = 1:100
        dist(i) = real((18.97 + sqrt(x(i)*-111.96+329.20))/(2*(x(i)+0.2739)));
    end
end

function dist = med_IR(x)
    for i = 1:100
        dist(i) = real((22.28 + sqrt(x(i)*-155.36+527.83))/(2*(x(i)-0.2023)));
    end
end

function dist = long_IR(x)
    for i = 1:100
        dist(i) = real((88.4 - sqrt(x(i)*-2530+7242.27))/(2*(x(i)-0.2262)));
    end
end