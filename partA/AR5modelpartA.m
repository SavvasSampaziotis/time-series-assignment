%% Load Time Series
clear;
clc;

%% Produce K windows of 250 samples each

% Set the path to load the data
Y = convert2stationary();

x = Y;
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
% the mean of trainingData
Xxtesting = cell(K,1);

for k = 1 : K
    y = x{k};
    
    ytraining = y(1:trainingSize);
    meanXtraining(k) = mean(ytraining);
    
    Xtraining{k} = ytraining - meanXtraining(k);
    
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
    xPred = Xpredicted{k}(2:end);
    xTest = Xtesting{k}(1:end-1);
%     NRMSE(k) = nrmse(Xtesting{k}, Xpredicted{k});
    NRMSE(k) = nrmse(xTest, xPred);
    R_2(k) = calculateR2(xPred, xTest);
end

%% Display metrics values

% If you want to read the NRMSE and R_2 arrays set diplayValues to 1
displayValues = 1;

if displayValues
    
    fprintf('NRMSE:\n');
    for k = 1 : K
        fprintf('%0.4f ',  NRMSE(k));
    end
    fprintf('\nR^2:\n');
    for k = 1 : K
        fprintf('%0.4f ',  R_2(k));
    end
    fprintf('\n');
    
end
%% Plotting prediction error

Xerror = cell(K,1);
for k = 1 : K
    Xerror{k} = Xtesting{k} - Xpredicted{k};
end

figure(1);
plot_X(Xerror, 'prediction error');