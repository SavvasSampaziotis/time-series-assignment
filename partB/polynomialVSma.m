%% Clear workspace and load path to MATLAB

clear;
clc;
addpath( genpath('../'));

%% Load Time Series

data = load('../data/dat19.dat');

y = data(6:6:end);
y = (y-mean(y))/std(y);

N = length(y);
n = 1 : N;

orderMA = 21;
ordenPoly = 21;

mu2V = polynomialfit(y,ordenPoly);
maV = movingaveragesmooth2(y, orderMA);

datapoly = y - mu2V;
dataMA = y - maV;

figure(1); clf;
plot(y);
xlim([0 N])
xlabel('weeks')
title('Dat19 - currency Balance resampled');

%% Plot data with filters

figure(2); clf;
subplot(2,1,1)
plot(n,y,n,mu2V);
title1 = sprintf('Polynomial order %d', ordenPoly);
legend('real', 'plynomial');
xlabel('weeks')
xlim([1 N])
title(title1);

subplot(2,1,2)

plot(n,y,n,maV);
title1 = sprintf('MA filter order %d', orderMA);
legend('real', 'MA filter');
xlim([1 N])
title(title1);
xlabel('weeks')


%% Plot diferences
downlim = floor(min([datapoly ; dataMA]));
upperlim = ceil(max([datapoly ; dataMA]));

figure(3); clf;
subplot(2,1,1)
plot(n,datapoly);
title1 = sprintf('Detrended time series with polynomial order %d', ordenPoly);
title(title1);
xlabel('weeks')
xlim([1 N])
ylim([downlim upperlim])

subplot(2,1,2)
plot(n,dataMA);
title1 = sprintf('Detrended time series with MA order %d', orderMA);
title(title1);
xlabel('weeks')
xlim([1 N])
ylim([downlim upperlim])





