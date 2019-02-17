function [  ] = plot_util( x, plotfun, titlePart )
    %PLOT_K Summary of this function goes here
    %   Detailed explanation goes here
    % figure(1);
    clf;
    if isa(x, 'double')
        x = {x};
    end
    for k=1:length(x)
        subplot(3,4,k);
        
        plotfun(x{k})
%         v = axis; v(2) = length(x{k});
%         axis(v);
%         pbaspect([1 0.5 1])
        title(['window ', num2str(k)]);
        grid on;
    end
    suptitle(['dat19: ', titlePart]);
    
end

