%% Load Time Series
clear;
clc;
load('./data/dat19.dat');
addpath( genpath('.'));


y = dat19(6:6:end);
y = (y-mean(y))/std(y);
N = length(y);
n = 1 : N;

ordenPoly = 21;
maxLags = 20;


mu2V = polynomialfit(y,ordenPoly);
y = y - mu2V;

save('./data/detrendB.mat', 'y');
%% Plot autocorr and partial corr

figure(1); clf;
plot(y);
xlim([1 N])
xlabel('weeks')
title(['Detrended Time series - polynomifal filter of ' num2str(ordenPoly) ' order']);

figure(2); clf;
autocorr(y, maxLags)

figure(3); clf;
parcorr(y, maxLags)

