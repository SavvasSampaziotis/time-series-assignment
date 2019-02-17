function [aicMap, bicMap, nrmseMap] = fitK(y, index)

P = [1:10];
Q = [0:5, 20 ,30];

np = length(P);
nq = length(Q);

aicMap = zeros(np, nq);
bicMap = zeros(np, nq);
nrmseMap = zeros(np, nq);
for p = 1 : np
    for q = 1 : nq
        N = length(y);
        [nrmseV,phiV,thetaV,SDz,aicS,fpeS,R2,armamodel] = fitARMA(y,P(p),Q(q));
        bicS = 2*log(SDz) + 2*log(N)*(p+q)/N;
        aicMap(p , q) = aicS;
        bicMap(p, q) = bicS;
        nrmseMap(p, q) = nrmseV;
        fprintf('Window %d: AR(%d) MA(%d) finished\n', index, P(p), Q(q));
    end
end

end

