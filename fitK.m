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


%% Surf
% figure(1); clf; hold on;
%
% lgn = strings(Q+1, 1);
% for num = 0 : Q
%     lgn(num+1) = sprintf(" q = %d", num);
% end
%
%
% temp = aicMap;
% Plim = 0 : P;
% for i = 0 : Q
%     plot(Plim, temp(i+1,:));
% end
% xlabel('p');
% ylabel('IC');
% legend(lgn, 'Location', 'NorthEast')
%
%
%
% [minQ,minP] = find(min(temp(:))==temp);
% minP = minP-1;
% minQ = minQ-1;
% % plot3(minP, minQ, min(temp(:)), 'rX', 'MarkerSize',20 )
% % xlabel('p')
% % ylabel('q')
% fprintf(" Least was found as a AR(%d) MA(%d)\n", minP, minQ);
% fprintf(" Least had NRMSE of %0.3f\n", nrmseMap(minQ+1,minP+1));

end

