%% convert2stationary()
% Loads the Timeseries data, converts it to Stationary Timeseries and
% breaks it into 250-wide windows.
%
% Returns: a Kx1 cell array of K stationary time-series in total.
% If the function is called with no return argument, the function will plot
% the timeseries, its ACF and PACF automatically.
%
function Y = convert2stationary()
    %% Load Time Series
    %     clear;
    load('./data/dat19.dat');
    
    %% Detrend whole
    % Apply the MA method for Trend Estimation and Removal.
    dat19 = method4(dat19, 21);
    
    %% Produce K windows of 250 samples each
    N = length(dat19);
    K = floor(N/250);
    x = cell(K,1);
    for k=1:K
        x{k} = dat19( [1:250] + (k-1)*250 );
    end
    
    %% Apply further Transformations to each individual window
    Y = cell(K,1);
    
    for k=1:K
        y = x{k};
        
        % Remove outliers
        [y, xOutNum] = removeOutlier(y);
        if xOutNum
            disp([num2str(xOutNum),' Outliers removed from time series window No.' num2str(k)]),;
        end;
        
        % Center and Normalize  
        y = (y-mean(y))/std(y);
        
        Y{k} = y; 
    end
    
    %% Plot De-trended Time Series
    if nargout == 0
        figure(1);
        plot_X(Y, '');
        
        figure(2);
        plot_AUTOCORR(Y,20);
        
        figure(3);
        plot_PARCORR(Y, 20);
    end
end
