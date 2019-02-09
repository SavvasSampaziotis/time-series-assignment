function [ y ] = method5( x )
    y = x - movingaveragesmooth2(x, 2 );
    y = (y-mean(y))/std(y);
end

