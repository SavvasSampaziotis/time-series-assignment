%% Load Time Series
clear;
load('./data/dat19.dat');

%% Produce K windows of 250 samples each
N = length(dat19);
K = floor(N/250);
x = cell(K,1);
for k=1:K
    x{k} = dat19( [1:250] + (k-1)*250 );
end

%% Convert Each time series to stationary
Y = cell(K,1);
isStationary = -ones(1,K);
isRandom = -ones(1,K);
 warning off
for k=1:K
    y = x{k};
    
%     y = method1(y);
    y = method4(y,2);
    [yr, xOutNum] = removeOutlier(y);
    if xOutNum, disp([k,xOutNum]), end;
    
    y = (y-mean(y))/std(y);
    yr = (yr-mean(yr))/std(yr);
    
    Y{k} = y;
    Yr{k} = yr;
    isStationary(k) = adftest(y, 'lags', 2);
    
    % A PorntMantau Test (Ljung Box Test) to see whether there is
    % significant autocorrelation in the signal. If not, then it's
    % considered random :)
%     isRandom(k) = lbqtest(yr)==0;
    isRandom(k) = ~all(portmanteauLB(yr,20,0.05, 'savvas'));
end
 warning on
disp(['Is Stationary:  ', num2str(isStationary)]);
disp(['Is Random:  ', num2str(isRandom)]);

%% Plot De-trended Time Series
figure(1);
plot_X(Y);

figure(2);
plot_AUTOCORR(Y,20);

figure(3);
plot_PARCORR(Y, 20);

%% Plot De-trended Time Series
figure(4);
plot_X(Yr);

figure(5);
plot_AUTOCORR(Yr,20);

figure(6);
plot_PARCORR(Yr, 20);

 %%
% figure(10);
% tempfun = @(x) hist(x,30);
% plot_util(Yr, tempfun)

%%
save('./data/data19_detrended.mat', 'Y', 'Yr');