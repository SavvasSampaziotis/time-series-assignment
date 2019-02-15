function [ y ] = method4( x, order )
    y = x - movingaveragesmooth2(x, order);
%     y = (y-mean(y))/std(y);
end

