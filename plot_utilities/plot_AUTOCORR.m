function [  ] = plot_AUTOCORR( x, maxLag )
%PLOT_K Summary of this function goes here
%   Detailed explanation goes here

plotFun = @(x) autocorr(x, maxLag); 
plot_util(x, plotFun, 'Autocorrelation')

% Not working yet
% plot_CORR_util(x, maxLag, @parCorr, 'Partial Correlation')
end

