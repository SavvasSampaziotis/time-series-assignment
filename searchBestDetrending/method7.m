function [ y ] = method7( x )
    y = x - movingaveragesmooth2(x, 4 );
    y = (y-mean(y))/std(y);
end

