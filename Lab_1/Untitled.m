clear

short_mat = dir('short/*.mat');
med_mat = dir('medium/*.mat');
long_mat = dir('long/*.mat');

short_means = zeros(7, 1);
med_means = zeros(8, 1);
long_means = zeros(8, 1);

for q = 1:length(short_mat)
    filename = strcat('short/', short_mat(q).name);
    data = load(filename);
    average = mean(data.data);
    short_means(q) = average;
end

for q = 1:length(med_mat)
    filename = strcat('medium/', med_mat(q).name);
    data = load(filename);
    average = mean(data.data);
    med_means(q) = average;
end

for q = 1:length(long_mat)
    filename = strcat('long/', long_mat(q).name);
    data = load(filename);
    average = mean(data.data);
    long_means(q) = average;
end

short_dists = [4; 8; 12; 16; 20; 24; 30];
med_dists = [10; 20; 30; 40; 50; 60; 70; 80];
long_dists = [20; 40; 60; 80; 100; 120; 140; 150];
plot(short_dists, short_means)
hold on
plot(med_dists, med_means)
hold on
plot(long_dists, long_means)
legend("Short IR", "Medium IR", "Long IR")
xlabel("Distances (CM)")
ylabel("Mean Voltage Measurements")


short_f = fit(short_dists, short_means, 'poly4')
plot(short_f,short_dists,short_means)
short_errors = zeros(7, 1);
for i = 1:length(short_dists)
    dist = short_dists(i);
    f_val = short_f(dist);
    error = f_val - short_means(i);
    short_errors(i) = error;
end
max_short_error = max(short_errors)
mean_short_error = mean(short_errors)

medium_f = fit(med_dists, med_means, 'exp2')
plot(medium_f,med_dists,med_means)
med_errors = zeros(8, 1);
for i = 1:length(med_dists)
    dist = med_dists(i);
    f_val = medium_f(dist);
    error = f_val - med_means(i);
    med_errors(i) = error;
end
max_med_error = max(med_errors)
mean_med_error = mean(med_errors)

long_f = fit(long_dists, long_means, 'poly1')
plot(long_f,long_dists,long_means)
long_errors = zeros(8, 1);
for i = 1:length(long_dists)
    dist = long_dists(i);
    f_val = long_f(dist);
    error = f_val - long_means(i);
    long_errors(i) = error;
end
max_long_error = max(long_errors)
mean_long_error = mean(long_errors)

xlabel("Distances (CM)")
ylabel("Mean Voltage")











  
