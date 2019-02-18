%% Clear workspace
clear;
clc;

%% Load Time Series

data = load('./data/detrendB.mat');
y = data.y;

N = length(y);
n = 1 : N;
%% 1
%
% data2 = embeddelays(y, 2, 1);
% data3 = embeddelays(y, 3, 1);
%
% figure(1)
% plotd2d3(data2, 'Scatter plot in 2d');
%
% figure(2)
% plotd2d3(data3, 'Scatter plot in 3d');

%% 2

% tau = 1;
% mmax = 10;
% fnnM = falsenearest2(y, tau, mmax, 10, 0, 'Weekly Currency Balance -');
% suptitle('');
% for m = 1 : mmax
%     if fnnM(m,2) < 0.01 || isequaln(fnnM(m,2),NaN)
%         mbest = m;
%         break;
%     end
% end
% fprintf('The best embedding dimension is %d\n', mbest);
%% 3
%use correlationdimension

% [rcM,cM,rdM,dM,nuM] = correlationdimension(datapoly,tau,mmax,tittxt,fac,logrmin,logrmax);
% [rcM,cM,rdM,dM,nuM] = correlationdimension(y,1,10,'what',2);
%
% close all;
% clc;
% or better
% [rcM,cM,rdM,dM,nuM] = correlationdimension(y,1,mbest+1,'with mmax ',2);

%% 4

% [nrmseV,preM] = localfitnrmse(xV,tau,m,Tmax,nnei,q,tittxt)
% [nrmseV,phiV] = linearfitnrmse(xV,m,Tmax,tittxt)
K = 20;
M = 10;
tau = 1;
Tmax = 1;

nrmseLAP = zeros(M, K);
nrmseLAPpred = zeros(M, K);
real = y(0.6*N+1:end);
xTraining = real(1:end-1);

for m = 1 : M
    for k = 1 : K
        
        [nrmseV, preM] = localpredictnrmse2(y,0.4*N,tau,m,Tmax,k);
        
        xPred = preM(1:end,2);
        xTest = y(preM(1:end,1));
        nrmseLAPpred(m,k) = nrmse(xTest,xPred);
    end
end

minErrorPred = min(nrmseLAPpred(:));
[minMpred, minKpred] = find(nrmseLAPpred == minErrorPred);
fprintf('Least nrmse for prediction at m = %d and k = %d\n', minMpred, minKpred);
minErrorPred

%%
[nrmseV, preM] = localpredictnrmse2(y, 0.4*N, tau,minMpred,Tmax,minKpred);

xPred = preM(1:end,2);
xTest = y(preM(1:end,1));

NRMSE_A = nrmse(xTest,xPred);

figure(1); clf;
subplot(2,1,1);
plot([xPred,xTest]); legend('prediction', 'testing data')
title(['Prediction - Test Set Comparison']);

if K == 1
    suptitle(['Zeroth Order Local Model: k=1 m=', num2str(minMpred)])
else
    suptitle(['Local Average Predictor: k=', num2str(minKpred), ' m=', num2str(minMpred)])
end
grid on

subplot(2,1,2);
plot([xPred-xTest]);
title('Prediction Error')
ylabel('y_p_r_e_d - y_t_e_s_t');
grid on

%%
% [nrmseV, preM] = localpredictnrmse2(y,0.4*N,tau,minMpred,Tmax,minKpred);
% xPred = preM(1:end,2);
% xTest = y(preM(1:end,1));
% plot([xPred,xTest]); legend('prediction', 'testing data')
% nrmse(xTest,xPred)