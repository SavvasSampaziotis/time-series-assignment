function R2 = calculateR2(output, data)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    data_cap = mean(data);
    SSres = sum( (data - output) .^ 2 );
    SStot = sum( (data - data_cap) .^ 2 );
    R2 = 1 - SSres / SStot;
end