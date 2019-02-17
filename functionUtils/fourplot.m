function STATS = fourplot(X)
    % FOURPLOT - Four-plot for efficient visual exploratory data analysis
    %
    %   FOURPLOT(X) creates for the values in X a "four-plot" that allows for a
    %   powerful and efficient visual inspection of the four underlying
    %   assumptions of univariate statistical analyses. Descriptive statistics
    %   are printed out in the command window.
    %
    %   X is a vector of observational values. It should be numerical and
    %   cannot contain NaNs or Infs.
    %
    %   In four subplots, the run sequence plot (X[k] vs k), a lag plot (X[k]
    %   vs X[k-1]), a histogram, and a normal probablity plot are shown. Within
    %   these axes, the mean value of X is drawn as a straight line. In
    %   addition, a 5th panel shows a box-and-whisker plot of X.
    %
    %   If the four underlying assumptions holds, the four plots will have a
    %   characteristic appearance.
    %   1. If the fixed location assumption holds, then the run sequence plot
    %      will be flat and non-drifting.
    %   2. If the fixed variation assumption holds, then the vertical spread in
    %      the run sequence plot will be the approximately the same over the
    %      entire horizontal axis.
    %   3. If the randomness assumption holds, then the lag plot will be
    %      structureless and random.
    %   4. If the fixed distribution assumption holds, in particular if the
    %      fixed normal distribution holds, then the histogram will be
    %      bell-shaped, and the normal probability plot will be linear.
    %
    %   The box-and-whisker plot will show the median (red line), mean and SD (in
    %   blue), the 25th and 75th percentile (the box), and outliers (plus
    %   symbols), if any. The whiskers are the lowest value still within 1.5
    %   times the inter-quartile range (IQR) of the lower quartile, and the
    %   highest value still within 1.5 IQR of the upper quartile. Raw data are
    %   plotted in gray.
    %
    %   STATS = FOURPLOT(X) returns some statistical values in the
    %   structure STATS. Descriptive statistics are not printed.
    %
    %   Examples:
    %     % case 1: the four assumptions hold
    %       X = 20 + randn(100,1) * 10 ;
    %       fourplot(X) % nice, we can use classical statistics!
    %
    %     % case 2: data is oscillating, which is not immediately clear
    %       unknown = cumsum(rand(1000,1)) ;
    %       unknown = unknown(randperm(numel(unknown))) ;
    %       X = sin(unknown) ; % X looks random (see, e.g., run sequence) ..
    %       fourplot(X)        % .. but it is not!
    %
    %   The usefulness of a four-plot extends beyond inspection of univariate
    %   and time series data. For instance, it can be used to inspect the
    %   residuals of model fit to determine whether the underlying error term
    %   of the model fullfills the assumptions, no  matter how complicated the
    %   model may be.
    %
    %   Example:
    %       x = 2*rand(100,1) ; y = exp(x) ; % the complex data
    %       par = polyfit(x,y,1) ;           % a (too) simple model
    %       res = y - polyval(par,x) ;       % residuals
    %       fourplot(res)                    % -> our model is poor!
    %
    %   More information can be found on the internet, e.g.,
    %   http://www.itl.nist.gov/div898/handbook/eda/section2/eda23.htm
    %
    %   See also NORMPLOT (Statistics Toolbox)
    %            MEAN, MEDIAN
    % tested in Matlab 2010b, but should work in most ML releases
    % version 3.0 (march 2015)
    % (c) Jos van der Geest
    % email: jos@jasen.nl
    % History
    % 1.0 (july 2013) created
    % 2.0 (july 2013) box-and-whisker plot added
    % 3.0 (march 2015) print output of descriptive statistics
    % a few sanity checks on the input
    narginchk(1,1) ;
    N = numel(X) ;
    if N<1 || ~isnumeric(X),
        error('Data should be a numerical vector with some values.') ;
    end
    X = reshape(X,1,N) ; % make a row vector
    if any(isnan(X) | ~isfinite(X)),
        error('Data cannot contain NaNs/Infs.') ;
    end
    minmaxX = [min(X) max(X)] ;
    if minmaxX(1)==minmaxX(2),
        error('No variation in data. Nothing to do, really ...') ;
    else
        % data limits are use to scale the plots properly
        datalimits = minmaxX + (0.02 * [-1 +1] .* (minmaxX(2)-minmaxX(1))) ;
    end
    ix = 1:N ;
    MeanX = mean(X) ; % mean is used as a reference line in the plots
    SDX = std(X) ;    % standard deviation
    % create a new figure, holding the four subplots
    figure ('name','4-Plot') ;
    % ---------------------------------------------
    % plot 1 - RUN SEQUENCE
    ah(1) = subplot(2,3,1) ;
    hold on ;
    plot([0 N+1],[MeanX MeanX],'b-') ;  % reference line
    plot(ix, X, 'b.-') ;
    hold off ;
    xlabel('k') ;
    ylabel('X(k)') ;
    title('RUN SEQUENCE') ;
    % ---------------------------------------------
    % plot 2 - LAG
    ah(2) = subplot(2,3,2) ;
    hold on ;
    plot([datalimits NaN MeanX MeanX], ...
        [MeanX MeanX NaN datalimits],'b-') ; % reference line
    plot(X([2:end 1]), X,'b+') ;
    hold off ;
    xlabel('X(k-1)') ;
    ylabel('X(k)') ;
    title('LAG') ;
    % ---------------------------------------------
    % plot 3 - HISTOGRAM
    ah(3) = subplot(2,3,4) ;
    [Nh,Xh] = hist(X(:),10) ; % count into 10 bins
    Nh = Nh ./ N ; % proportions
    hold on ;
    bar(Xh,Nh) ;
    plot([MeanX MeanX],get(ah(3),'ylim'),'b-') ; % reference line
    hold off ;
    xlabel('Value') ;
    ylabel('Proportion') ;
    title('HISTOGRAM') ;
    % ---------------------------------------------
    % plot 4 - NORMAL PROBABLITY
    ah(4) = subplot(2,3,5) ;
    X = sort(X) ; % sort the data
    P = -sqrt(2)*erfcinv(2*(ix-0.5)/N) ; % the normal probabilities for each index
    hold on ;
    plot(X,P,'b+') ;
    par = polyfit(X,P,1); % fit a straight line to visualize deviations
    plot(datalimits,polyval(par,datalimits),'r-') ; % fit
    plot([datalimits NaN MeanX MeanX],[0 0 NaN get(ah(4),'ylim')],'b-') ; % reference line
    hold off ;
    xlabel('sorted X') ;
    ylabel('Probability') ;
    title('NORMAL PROBABLITY') ;
    % ---------------------------------------------
    % plot 5 - BOXPLOT
    ah(5) = subplot(2,3,[3 6]) ; hold on ;
    % calculate the various parts of the Box plot
    XQ = zeros(5,1) ; % pre-allocation
    ixq = round([.25 .5 .75]*N) ; %25, 50, and 75th percentile
    ixq(ixq<1) = 1 ;
    XQ(2:4) = X(ixq) ; % 1st, 2nd (median), and 3rd quartile (Q25, Q50, & Q75)
    IQR = XQ(4)-XQ(2) ;  % inter-quartile range IQR
    IsOutlierBelow = X < XQ(2) - 1.5 * IQR ;
    XQ(1) = min(X(~IsOutlierBelow)) ; % lowest value within 1.5 times the IQR below Q25
    IsOutlierAbove = X > XQ(4) + 1.5 * IQR ;
    XQ(5) = max(X(~IsOutlierAbove)) ; % highest value within 1.5 times the IQR above Q75
    IsOutlier = IsOutlierBelow | IsOutlierAbove ;
    Xout = X(IsOutlier) ;  % outliers
    % plotting individual values with a little jitter
    xposjitter = ((0:N-1)-(N/2))./(2*N) ;
    xposjitter = xposjitter(randperm(N)) ;
    xph = plot(xposjitter,X,'ko') ;
    set(xph,'markeredgecolor',[.7 .7 .7],'markerfacecolor',[.7 .7 .7],'markersize',4) ;
    % create the box-and-whisker-plot
    tempy = MeanX + [1 1 1 -1 -1 -1] * SDX ;
    tempx = 0.2 + [-1 1 0 0 -1 1] * 0.05 ;
    plot(tempx, tempy,'b-') ; % standard deviation error bars
    plot(0.2,MeanX,'bs', 'markerfacecolor', 'b') ; % mean value
    plot([-1 1],XQ([3 3]),'r-') ; % median
    plot([-1 -1 1 1 -1],XQ([2 4 4 2 2]),'k-') ; % box
    plot([0 0 -1 1]/2,XQ([4 5 5 5]),'k-') ; % whiskers at 1.5
    plot([0 0 -1 1]/2,XQ([2 1 1 1]),'k-') ;
    plot(xposjitter(IsOutlier), Xout,'k+') ;
    hold off ;
    title('BOXPLOT') ;
    ylabel('Values') ;
    set(ah(5),'xtick',[],'xlim',[-1.5 1.5]) ;
    % ---------------------------------------------
    % make the limits congruent for easier inpsection
    set(ah([2 3 4]),'xlim', datalimits) ;
    set(ah([1 2 5]),  'ylim', datalimits) ;
    set(ah(1),'xlim',[0 N+1]) ;
    set(ah,'box','on') ;
    if nargout,
        % return some statistics
        STATS.N    = N ;
        STATS.mean = MeanX ;
        STATS.SD   = SDX ;
        STATS.Q25  = XQ(2) ;
        STATS.Q50  = XQ(3) ;
        STATS.Q75  = XQ(4) ;
        STATS.IQR  = IQR ;
        STATS.SortedValues = X ;
        STATS.IsOutlier = IsOutlier ;
    else
        % print out descriptives
        disp('FOUR PLOT') ;
        fprintf('  N     : %d\n', N) ;
        fprintf('  Mean  : %.2f\n', MeanX) ;
        fprintf('  SD    : %.2f\n', SDX) ;
        fprintf('  Var   : %.2f\n', var(X)) ;
        fprintf('  Minimum  : %.2f\n', minmaxX(1)) ;
        fprintf('  Maximum  : %.2f\n', minmaxX(2)) ;
        fprintf('  Median   : %.2f\n', XQ(3)) ;
        fprintf('  Q25      : %.2f\n', XQ(2)) ;
        fprintf('  Q75      : %.2f\n', XQ(4)) ;
        fprintf('  IQR      : %.2f\n', IQR) ;
        fprintf('  # outliers below : %d\n', sum(IsOutlierBelow)) ;
        fprintf('  # outliers above : %d\n', sum(IsOutlierAbove)) ;
    end
end