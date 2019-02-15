%% Load Time Series
clear;
clc;
load('./data/dat19.dat');
addpath( genpath('.'));

figure(1);
y = dat19(6:6:end);
n = 1 : length(y);
plot(y);


figure(2); clf;
for order = 2 : 9
   subplot(4,2,order-1)
   mu2V = polynomialfit(y,order);
   plot(n,y,n,mu2V);
   title1 = sprintf('Order %d', order);
   title(title1);
end

figure(3); clf;
for order = 2 : 9
   subplot(4,2,order-1)
   mu2V = polynomialfit(y,order);
   plot(y - mu2V);
   title1 = sprintf('Order %d', order);
   title(title1);
end

