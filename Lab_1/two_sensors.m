clear

double_mat = dir('two_sensor/*.mat');

med_means = zeros(5, 1);
med_dists = zeros(5, 1);
long_means = zeros(5, 1);
long_dists = zeros(5, 1);

syms x y

for q = 1:length(double_mat)
    filename = strcat('two_sensor/', double_mat(q).name);
    data = load(filename);
    med_average = mean(data.data(:, 1));
    med_means(q) = med_average;
    eqn_1 = med_average == 4.294*exp(-0.1062*x)+0.9991*exp(-0.0136*x);
    med_dists(q) = solve(eqn_1,x);
    %solve(eqn_1,x)
    
    long_average = mean(data.data(:, 2));
    long_means(q) = long_average;
    eqn_2 = long_average == 9.969e-5*y+ 0.57;
    long_dists(q) = solve(eqn_2,y);
    %solve(eqn_2,y)
end


f(x) = 
h = finverse(



