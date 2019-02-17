%% Clear workspace
clear;
clc;

%% Load Time Series

data = load('../data/detrendB.mat');
y = data.y;

N = length(y);
n = 1 : N;
%% 1

data2 = embeddelays(y, 2, 1);
data3 = embeddelays(y, 3, 1);

figure(1)
plotd2d3(data2, 'Scatter plot in 2d');

figure(2)
plotd2d3(data3, 'Scatter plot in 3d');

%% 2

tau = 1;
mmax = 10;
fnnM = falsenearest(y, tau, mmax);

for m = 1 : mmax
    if fnnM(m,2) < 0.01 || isequaln(fnnM(m,2),NaN)
        mbest = m;
        break;
    end
end
fprintf('The best embedding dimension is %d\n', mbest);
%% 3
%use correlationdimension

% [rcM,cM,rdM,dM,nuM] = correlationdimension(datapoly,tau,mmax,tittxt,fac,logrmin,logrmax);
% [rcM,cM,rdM,dM,nuM] = correlationdimension(y,1,10,'what',2);

close all;
clc;
% or better
[rcM,cM,rdM,dM,nuM] = correlationdimension(y,1,mbest+1,'with mmax ',2);

%% 4

% [nrmseV,preM] = localfitnrmse(xV,tau,m,Tmax,nnei,q,tittxt)
% [nrmseV,phiV] = linearfitnrmse(xV,m,Tmax,tittxt)
K = 15;
M = mbest + 1;
tau = 1;
Tmax = 1;

nrmseLAP = zeros(M, K);
nrmseLAPpred = zeros(M, K);

for m = 1 : M
    for k = 1 : K
        [nrmseV,preM] = localfitnrmse(y,tau,m,Tmax,k);
        nrmseLAP(m,k) = nrmseV;
        [nrmseV,phiV] = localpredictnrmse(y,0.4*N,tau,m,Tmax,k);
        nrmseLAPpred(m,k) = nrmseV;
    end
    
end

minError = min(nrmseLAP(:));
[minM, minK] = find(nrmseLAP == minError);
fprintf('Least nrmse for fitting at m = %d and k = %d\n', minM, minK);
minErrorPred = min(nrmseLAPpred(:));
[minMpred, minKpred] = find(nrmseLAPpred == minErrorPred);
fprintf('Least nrmse for prediction at m = %d and k = %d\n', minMpred, minKpred);



