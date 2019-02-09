function [ y ] = method2( x )
    %METHOD1 Summary of this function goes here
    %   Detailed explanation goes here
    y = diff(log(x));
    y = (y-mean(y))/std(y);
end

