%% Load Time Series
clear;
clc;
addpath( genpath('.'));

%% Produce K windows of 250 samples each

% Set the path to load the data
data = load('./data/data19_detrended21.mat');

x = data.Yr;
K = length(x);

%% Initialise parameters
P = 5;
Q = 0;
trainingSize = 150;

% Part of the data used for training
Xtraining = cell(K,1);

% Mean of the data used for training
meanXtraining = zeros(K,1);

% Part of the data used for testing
Xtesting = cell(K,1);

% Part of the data used for prediction. It contains the testingData minus
% the meanof trainingData
Xxtesting = cell(K,1);

for k = 1 : K
    y = x{k};
    
    ytraining = y(1:trainingSize);
    meanXtraining(k) = mean(ytraining);
    
    Xtraining{k} = y(1:trainingSize) - meanXtraining(k);
    
    Xtesting{k} = y(trainingSize-P:end);
    Xxtesting{k} = y(trainingSize-P:end) - meanXtraining(k);
end

%% Fit ARMA(P,Q)
Xpredicted = cell(K,1);
NRMSE = zeros(K,1);
R_2 = zeros(K,1);

for k = 1 : K
    armamodel = armax(Xtraining{k}, [P Q]);
    Xpredicted{k} = predict(armamodel,Xxtesting{k},1) + meanXtraining(k);
    NRMSE(k) = nrmse(Xtesting{k},Xpredicted{k});
    R_2(k) = calculateR2(Xpredicted{k}, Xtesting{k});
end

% If you want to read the NRMSE and R_2 arrays then uncomment the below
% section

% fprintf('NRMSE:\n');
% for k = 1 : K
%     fprintf('%0.3f ',  NRMSE(k));
% end
% fprintf('\nR^2:\n');
% for k = 1 : K
%     fprintf('%0.3f ',  R_2(k));
% end
% fprintf('\n');
%% Plotting 
Xerror = cell(K,1);
for k = 1 : K
    Xerror{k} = Xtesting{k} - Xpredicted{k};
end

figure(1); hold on;
plot_X(Xerror, 'prediction error');