%% Load Time Series
clear;
load('./data/dat19.dat');

%% Detrend whole
dat19 = method4(dat19, 21);

%% Produce K windows of 250 samples each
N = length(dat19);
K = floor(N/250);
x = cell(K,1);
for k=1:K
    x{k} = dat19( [1:250] + (k-1)*250 );
end

%% Convert Each time series to stationary
Y = cell(K,1);

for k=1:K
    y = x{k};
    
%     y = method1(y);
%     y = method4(y,2);
    [y, xOutNum] = removeOutlier(y);
    if xOutNum, disp([k,xOutNum]), end;
    
    y = (y-mean(y))/std(y);
    
    Y{k} = y;
    
end

%% Plot De-trended Time Series
% figure(1);
% plot_X(Y);
% 
% figure(2);
% plot_AUTOCORR(Y,20);
% 
figure(3);
plot_PARCORR(Y, 20);

%%
save('./data/data19_detrended.mat', 'Y');

