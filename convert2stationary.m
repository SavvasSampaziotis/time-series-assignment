%% Load Time Series
clear;
clc;
load('./data/dat19.dat');
addpath( genpath('.'));

%% Produce K windows of 250 samples each
N = length(dat19);
K = floor(N/250);
x = cell(K,1);
for k=1:K
    x{k} = dat19( (1:250) + (k-1)*250 );
end

%% Convert Each time series to stationary
Y = cell(K,1);
Yr = cell(K,1);
isStationary = -ones(1,K);
isStationaryR = -ones(1,K);
isRandom = -ones(1,K);
isRandomR = -ones(1,K);
warning off


% Select order for the MA filter
order = 15;
plotting = 1; % 1 for plotting, 0 for not

for k=1:K
    y = x{k};
    
    %     y = method1(y);
    y = method4(y,order);
    [yr, xOutNum] = removeOutlier(y);
    if xOutNum, disp([k,xOutNum]), end
    
    y = (y-mean(y))/std(y);
    yr = (yr-mean(yr))/std(yr);
    
    Y{k} = y;
    Yr{k} = yr;
    isStationary(k) = adftest(y, 'lags', 2);
    isStationaryR(k) = adftest(yr, 'lags', 2);
    
    % A PorntMantau Test (Ljung Box Test) to see whether there is
    % significant autocorrelation in the signal. If not, then it's
    % considered random :)
    isRandom(k) = lbqtest(y)==0;
    isRandomR(k) = lbqtest(yr)==0;
    %     isRandom(k) = ~all(portmanteauLB(yr,20,0.05, 'savvas'));
end
warning on
disp(['Is Stationary with outliers:  ', num2str(isStationary)]);
disp(['Is Stationary without outliers:  ', num2str(isStationaryR)]);
disp(['Is Random with outliers:  ', num2str(isRandom)]);
disp(['Is Random without outliers:  ', num2str(isRandomR)]);

%% Plot De-trended Time Series
if plotting
    figure(1);
    plot_X(Y, '');
    
    figure(2);
    plot_AUTOCORR(Y,20);
    
    figure(3);
    plot_PARCORR(Y, 20);
    
%% Plot De-trended Time Series without outliers
    figure(4);
    plot_X(Yr, 'without outliers');
    
    figure(5);
    plot_AUTOCORR(Yr,20);
    
    figure(6);
    plot_PARCORR(Yr, 20);
    
end
%%
% figure(10);
% tempfun = @(x) hist(x,30);
% plot_util(Yr, tempfun)

%% Save data
% filename = sprintf('./data/data19_detrended%d.mat', order);
% 
% save(filename, 'Y', 'Yr');



