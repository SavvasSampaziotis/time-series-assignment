%% Clear workspace
clear;
clc;
close all;

%% Initialise parameters
Y = convert2stationary();

x = Y;
K = length(x);
AICcm = zeros(K,2);
NRMSEm = zeros(K,2);
R2m = zeros(K,2);
A = cell(K,2);

windows = 1 : K;

%% Create ARMA models

for i = windows
    for p = 2:3
        y = x{i};
        [nrmseV,phiV,thetaV,SDz,aicS,fpeS,R2,armamodel] = fitARMA(y,p,0);
        AICcm(i, p-1) = aicS;
        NRMSEm(i, p-1) = nrmseV;
        R2m(i, p-1) = R2;
        A{i,p-1} = armamodel.a(2:end);
    end
end