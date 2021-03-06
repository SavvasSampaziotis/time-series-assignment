%% Select Information Criterion adb windows
ICdata = load('../data/ICcheck.mat');

IC = ICdata.AICm;
NRMSE = ICdata.NRMSEm;

windows = 1:11;
displayLeast = 0; % 1 if you want to diplay the position and nrmse of the
                  % ARMA with least value of AICc, 0 otherwise
%% Plotting

n = length(windows);
figure(100); clf;
for k = 1 : n
    subplot(ceil(n/2), 2, k); hold on;
    
    tempIC = IC{windows(k)};
    nrmseMap = NRMSE{windows(k)};
    
    P = 1:10;
    Q = [0:5, 20 ,30];
    %     Q = [0:5];  % Uncomment this if you want without the extra Q
    %     Q = [0 20 30]; % Uncomment this if you want big Q
    
    np = length(P);
    nq = length(Q);
    
    lgn = cell(nq, 1);
    for num = 1 : nq
        lgn{num} = sprintf(' q = %d', Q(num));
    end
    
    for i = 1:nq % this is the change for big Q [1 7 8]
        plot(P, tempIC(:,i));
    end
    xlabel('p');
    ylabel('AICc');
    
    title(['window ', num2str(windows(k))]);
    grid on;
    
    if displayLeast
        [minQ,minP] = find(min(tempIC(:))==tempIC);
        minP = minP-1;
        minQ = minQ-1;
        fprintf('\n \n \nWindow %d: Least was found as a AR(%d) MA(%d)\n', windows(k), minP, minQ);
        fprintf('Window %d: Least had NRMSE of %0.3f\n', windows(k), nrmseMap(minQ+1,minP+1));
    end
    
end
suptitle('dat19: IC');
legend(lgn, 'Location', 'Best')