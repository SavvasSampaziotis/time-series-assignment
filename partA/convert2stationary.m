%% Clear workspace and load path to MATLAB

clear;
clc;
addpath(genpath('../'));

%% Load Time Series

data = load('../data/dat19.dat');

%% Produce K windows of 250 samples each

N = length(data);
K = floor(N/250);
x = cell(K,1);

% Select order for the MA filter
order = 21;
plotting = 1; % 1 for plotting, 0 for not

y = method4(data,order);

for k=1:K
    x{k} = y( (1:250) + (k-1)*250 );
end

%% Convert Each time series to stationary

Y = cell(K,1);
isStationary = -ones(1,K);
isRandom = -ones(1,K);
warning off


for k=1:K
    y = x{k};

    [y, xOutNum] = removeOutlier(y);
    
    % Diplay in wich window and how many outliers have been removed
    if xOutNum, disp([k,xOutNum]), end
    
    y = (y-mean(y))/std(y);
    
    Y{k} = y;

    isStationary(k) = adftest(y, 'lags', 2);
    
    % A PorntMantau Test (Ljung Box Test) to see whether there is
    % significant autocorrelation in the signal. If not, then it's
    % considered random :)
    isRandom(k) = lbqtest(y)==0;
    %     isRandom(k) = ~all(portmanteauLB(yr,20,0.05, 'savvas'));
end

warning on
disp(['Is Stationary without outliers:  ', num2str(isStationary)]);
disp(['Is Random without outliers:  ', num2str(isRandom)]);

%% Plot De-trended Time Series without outliers
if plotting
    
    figure(1);
    plot_X(Y, '- Detrended');
    
    figure(2);
    plot_AUTOCORR(Y,40);
    
    figure(3);
    plot_PARCORR(Y, 20);
    
end

%% Save data

filename = '../data/data19_detrended.mat';
save(filename, 'Y');



