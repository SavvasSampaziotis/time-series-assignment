function [ y ] = method6( x )
    y = x - movingaveragesmooth2(x,3 );
    y = (y-mean(y))/std(y);
end

