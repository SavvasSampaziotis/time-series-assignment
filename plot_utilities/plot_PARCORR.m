function [  ] = plot_PARCORR( x, maxLag )
%PLOT_K Summary of this function goes here
%   Detailed explanation goes here

plotFun = @(x) parcorr(x, maxLag); 
plot_util(x, plotFun, 'Partial Correlation')

% plot_CORR_util(x, maxLag, @parCorr, 'Partial Correlation')

end

