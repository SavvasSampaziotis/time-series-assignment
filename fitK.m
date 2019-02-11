function [aicMap, bicMap, nrmseMap] = fitK(y, index)

P = 10;
Q = 7;

aicMap = zeros(Q+1,P+1);
bicMap = zeros(Q+1,P+1);
nrmseMap = zeros(Q+1,P+1);
for p = 0:P
    for q=0:Q
        N = length(y);
        [nrmseV,phiV,thetaV,SDz,aicS,fpeS,armamodel] = fitARMA(y,p,q);
        bicS = 2*log(SDz) + 2*log(N)*(p+q)/N;
        aicMap(q+1, p+1) = aicS;
        bicMap(q+1, p+1) = bicS;
        nrmseMap(q+1, p+1) = nrmseV;
        fprintf("Window %d: AR(%d) MA(%d) finished\n", index, p, q);
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

