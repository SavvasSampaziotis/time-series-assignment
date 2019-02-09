function [x, numOut, xOutliers] = removeOutlier(x)
    all_idx = 1:length(x);
    outlier_idx = abs(x - median(x)) > 3*std(x);
    
    xOutliers = x(outlier_idx);
    
    x(outlier_idx) = interp1(all_idx(~outlier_idx), x(~outlier_idx), all_idx(outlier_idx)) ;
    % Linearly interpolate over outlier idx for x
    
    numOut = sum(outlier_idx);
end