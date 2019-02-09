function [ y ] = method1( x )
    y = diff(x)/2;
    y = [0;y(:)];
%     y = (y-mean(y))/std(y);
% y = (y-mean(y))/max(abs(y));
end

