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

mu2V = polynomialfit(y,ordenPoly);
datapoly = y - mu2V;

%% Initialise parameters
P = 5;
Q = 0;
trainingSize = ceil(N*0.6);

% Part of the data used for training
ytraining = y(1:trainingSize);

% Mean of the data used for training
meanXtraining = mean(ytraining);

% Part of the data used for training with mean zero
Xtraining = ytraining - meanXtraining;

% Part of the data used for testing
Xtesting = y(trainingSize-P:end);

% Part of the data used for prediction. It contains the testingData minus
% the mean of trainingData
Xxtesting = y(trainingSize-P:end) - meanXtraining;


%% Fit ARMA(P,Q)

armamodel = armax(Xtraining, [P Q]);
Xpredicted = predict(armamodel,Xxtesting,1) + meanXtraining;
NRMSE = nrmse(Xtesting,Xpredicted);
R_2 = calculateR2(Xpredicted, Xtesting);

fprintf('\nNRMSE: %0.3f\n', NRMSE);
fprintf('R^2: %0.3f\n', R_2);

figure(1); clf;
plot(datapoly);
xlim([0 length(Xtesting)])
xlabel('weeks')
title1 = sprintf('Prediction Error for AR(%d) method', P);
title(title1);


