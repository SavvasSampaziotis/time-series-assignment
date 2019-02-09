function [ y ] = method3( x )
    %METHOD1 Summary of this function goes here
    %   Detailed explanation goes here
    y = diff(x)./x(2:end);
    y = (y-mean(y))/std(y);
end

