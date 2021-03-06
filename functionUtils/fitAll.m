clear;
clc;
close all;

%% Initialise parameters
data = load('../data/data19_detrended.mat');

x = data.Y;
K = length(x);
AICm = cell(K,1);
BICm = cell(K,1);
NRMSEm = cell(K,1);

%% Select Windows

% windows = [1  2  3];
windows = 1 : K;

%% Create ARMA models

for i = windows
    y = x{i};
    [aicMap, bicMap, nrmseMap] = fitK(y, i);
    AICm{i} = aicMap;
    BICm{i} = bicMap;
    NRMSEm{i} = nrmseMap;
end

%% Save data
filename = sprintf('../data/IC.mat');

save(filename, 'AICm', 'BICm', 'NRMSEm');

%% Select Information Criterion adb windows
ICdata = load('../data/ICcheck.mat');

IC = ICdata.AICm;
NRMSE = ICdata.NRMSEm;

windows = [1:11];
displayLeast = 0;
%% Plotting

figure(100); clf;
for k = 1 : length(windows)
    subplot(length(windows),1,k); hold on;
    
    tempIC = IC{windows(k)};
    nrmseMap = NRMSE{windows(k)};
    Q = size(tempIC,1) - 1;
    P = size(tempIC,2) - 1;
    
    lgn = strings(Q+1, 1);
    for num = 0 : Q
        lgn(num+1) = sprintf(' q = %d', num);
    end
    
    Plim = 0 : P;
    for i = 0 : Q
        plot(Plim, tempIC(i+1,:));
    end
    xlabel('p');
    ylabel('IC');
    legend(lgn, 'Location', 'NorthEast')
    title(['window ', num2str(windows(k))]);
    grid on;
    ylim([min(tempIC(:))-0.01 min(tempIC(:)) + 0.1]);
    
    if displayLeast
        [minQ,minP] = find(min(tempIC(:))==tempIC);
        minP = minP-1;
        minQ = minQ-1;
        fprintf('\n \n \nWindow %d: Least was found as a AR(%d) MA(%d)\n', windows(k), minP, minQ);
        fprintf('Window %d: Least had NRMSE of %0.3f\n', windows(k), nrmseMap(minQ+1,minP+1));
    end
end
suptitle('dat19: IC');