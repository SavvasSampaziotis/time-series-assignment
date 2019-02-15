%% Select Information Criterion adb windows
ICdata = load('./data/ICcheck.mat');

IC = ICdata.AICm;
NRMSE = ICdata.NRMSEm;

windows = 1:11;

%% Plotting
n = length(windows);
figure(100); clf;
for k = 1 : n
    subplot(ceil(n/2), 2, k); hold on;
    
    tempIC = IC{windows(k)};
    nrmseMap = NRMSE{windows(k)};
    P = [1:10];
    Q = [0:5, 20 ,30];
%     Q = [0:5];  % Uncomment this if you want without the extra Q
    
    np = length(P);
    nq = length(Q);
    
    lgn = strings(nq, 1);
    for num = 1 : nq
        lgn(num) = sprintf(' q = %d', Q(num));
    end
    
    for i = 1 : nq
        plot(P, tempIC(:,i));
    end
    xlabel('p');
    ylabel('AICc');
    legend(lgn, 'Location', 'BestOutside')
    title(['window ', num2str(windows(k))]);
    grid on;
%     ylim([min(tempIC(:))-0.01 min(tempIC(:)) + 0.1]);

    [minQ,minP] = find(min(tempIC(:))==tempIC);
    minP = minP-1;
    minQ = minQ-1;
    % plot3(minP, minQ, min(temp(:)), 'rX', 'MarkerSize',20 )
    % xlabel('p')
    % ylabel('q')
    fprintf('\n \n \nWindow %d: Least was found as a AR(%d) MA(%d)\n', windows(k), minP, minQ);
    fprintf('Window %d: Least had NRMSE of %0.3f\n', windows(k), nrmseMap(minQ+1,minP+1));
    
end
suptitle('dat19: IC');