%% This script is deprecated and not used in the final analysis of the project. 

%% Load Time Series
clear;
load('dat19.dat');

%% Produce K windows of 250 samples each
N = length(dat19);
K = floor(N/250);
x = cell(K,1);
for k=1:K
    x{k} = dat19( [1:250] + (k-1)*250 );
end

%% Convert Each time series to stationary
methodList = {@method1, @method2,@method3}; 
comment = {'Diff(.)','diff(log(.))','relative Diff'};
for order = 2:10
    methodList{end+1} = @(x) method4(x,order);
    comment{end+1} = ['MA(' num2str(order),')'];
end

M = length(methodList);

S = cell(K,M);
bestS = cell(K,1);
for k=1:K
    for m = 1:M
        
        y = methodList{m}(x{k});
        
        warning off
        [h,pValue,stat,cValue,reg] = adftest(y, 'lags', [0:30]);
%         warning on
        
        %         parcorr(y)
        temp = struct('isStationary', h, 'pValue', pValue, 'Maxstat', min(stat));
        S{k,m} = struct('windowId', k, 'data', y, ...
            'method', methodList{m}, 'comment', comment{m},....
            'adftest', temp);
    end
    
    % find best detrending method 
    minStat = 0;
    for m=1:M
       if minStat > S{k,m}.adftest.Maxstat
           minStat = S{k,m}.adftest.Maxstat;
           bestMethod = m;
       end
    end
    warning on
    bestS{k} = S{k,bestMethod};
end
bestS = cell2mat(bestS);


disp({bestS.comment})



% figure(1);
% plot_AUTOCORR(Y,50);
% tempfun = @(x) hist(x,30);
% plot_util(Y, tempfun)
% figure(2);
% % bar(sampleVariance(Y));
% mean(diff(sampleVariance(Y)'))
% plot_X(Y);
% figure(2);

%%
% r = autocorr(Y{1});
% k = length(r);
% Q = zeros(k,1);
% for i = 1:k
% %     Q(i) = (250/252)*sum( ([r(1:i)]'.^2)./(250-[1:i]));
% end

% plot(Q)