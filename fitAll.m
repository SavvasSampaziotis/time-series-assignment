
data = load('./data/data19_detrended.mat');

y = data.Yr{4};

P = 6;
Q = 4;

%% 
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
        disp([p,q])
    end
end


%% Surf 
[Pg,Qg] = meshgrid(0:P,0:Q);
figure(1); clf; hold on;

temp = aicMap;

if Q == 0
    plot(Pg,temp)
else
    mesh(Pg,Qg,temp);
end

[minQ,minP] = find(min(temp(:))==temp);
minP = minP-1;
minQ = minQ-1;
plot3(minP, minQ, min(temp(:)), 'rX', 'MarkerSize',20 )
xlabel('p')
ylabel('q')
disp([minP,minQ])
disp( nrmseMap(minP+1,minQ+1))


