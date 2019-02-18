%% Clear workspace
% clear;
% clc;

%% Load Time Series

data = load('./data/detrendB.mat');
y = data.y;

N = length(y);
n = 1 : N;

%% Initialise parameters

P = 1;
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
xPred = Xpredicted(2:end);
xTest = Xtesting(1:end-1);
NRMSE = nrmse(xTest, xPred);
R_2 = calculateR2(xPred, xTest);

fprintf('\nNRMSE: %0.4f\n', NRMSE);
fprintf('R^2: %0.4f\n', R_2);

e = xTest-xPred;
%% Plotting
% hold on;
figure(1); clf; 
% subplot(2,1,2)
plot([xTest, xPred]);
plot(e)
xlim([0 length(Xtesting)])
xlabel('weeks')
title1 = sprintf('Prediction vs Testing Dataset for AR(%d) method', P);
title(title1);
legend('Original Samples', 'Prediction');
grid on;
