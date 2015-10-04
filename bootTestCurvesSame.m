%% bootTestCurvesSame
%
%% [hypoth, pvalue, Pstats]  = bootTestCurvesSame(X, Y, nBoot, func, P0)
%
% Purpose:
% test whether the curves fitting Y = f(P, X) for some parameters, P, are the
% same. I.e., whether
% Y{1} = func(P, X{1}) and
% Y{2} = func(P, X{2}) are the same
%
% The test statistic used is the absolute value of the maximum difference
% between the curves, which is bootstrapped. The parameters that fit the
% data are also bootstrapped, and the mean and 95% confidence intervals of the
% parameters for both curves are returned. Other values are returned for
% plotting. Parallel processing (using PARFOR) is used to expedite the
% bootstrapping. If you can't support "parfor", change it to "for".
%
% Reference: Rodgers, J. L. (1999). The bootstrap, the jackknife, and the randomization test:
%       A sampling taxonomy. Multivariate Behavioral Research, 34(4), 441-456.
%
%% INPUT:
% X = cell array of two independent variables, each column is sampled from one population.
% Y = cell array of dependent variables
%        cell arrays are used because the length of x1, y1 and x2, y2 may
%        not be the same.
% nBoot = number of bootstrap samples. Number can be small, e.g., 10, for
%       testing program. For evaluations, nBoot should be about 1000-2000
%       (default = 2000)
% func = a function for the relationship between Y and X, determined by a parameter, P: Y = func(P, X)
%        P is fit using the Nelder-Mead Simplex via fminsearch()
% P0 = the initial guess for the parameters of func.
%       Note: If func and P0 are not given, the program fits the curves
%       with a smoothing spline, but does not return any P.
%% OUTPUT:
% hypoth (0 = fail to be different, 1 = different)
% pvalue = p-value for two-tailed test (e.g., pvalue < 0.05 for 95% level of significance)
% Pstats = a structure containing the statistics for the test:
%   .data = substructure with data based statistics
%       .D = The maximum distance of the fits to the original data
%       .P = parameter for fitting the actual data
%   .boot = substructure with bootstrapped population based statistics
%       .D = The maximum distances from each bootstrap sample
%       .P = all parameters fitted to the bootstrap data
%       .mnP = the mean of all parameter values (including original data)
%       .ciP = 95% confidence intervals on the mean of the parameters
%       .Xfit = x-points for Yfit, 1-D cell array
%       .Yfit = 2-D cell array of bootstrapped curves.
%
%% MATLAB Requirements
% distrib_computing_toolbox, matlab, statistics_toolbox
% if you use the smoothing spline, it also needs the curve_fitting_toolbox
%
%% Example: Self-test
% If the program is called with no inputs, a self-test will be run.
% It can fit the fake data with a parametric function, or if the
% flag "doTestSpline" in the code below is set to 1, a nonparametric function (smoothing
% spline) will be fit instead.
%
%%  function dispPci(mnP, ciP) to display parameter fits
% this function is used by the test program to display parameter fits in a
% table. Users can copy this to a separate m-file and use it for their
% problem

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 21may2015 Lance M. Optican Created
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2015, United States Government
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without modification, are permitted provided
% that the following conditions are met:
% 1. Redistributions of source code must retain the above copyright notice, this list of conditions and
% the following disclaimer.
% 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions
% and the following disclaimer in the documentation and/or other materials provided with the distribution.
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
% THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
% PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS
% BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
% DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
% SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
% CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
% TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [hypoth, pvalue, Pstats] = bootTestCurvesSame(X, Y, nBoot, func, P0)

% initialize to null
hypoth = [];
pvalue = [];
allD = [];
P = [];
mnP = [];
ciP = [];
Xfit = [];
Yfit = [];

if nargin < 3
    nBoot = 2000;  % number of monte carlo samples
end

if nargin == 0  % no input, so run test program
    runTestFunction
    return  % end of test program
end

if nargin < 5    % no function given, use smoothing spline
    func = @splineFunc;
    P0 = []; % empty param means use smoothing spline
end


%%  Compute
replacement = 1; % sample without replacement = 0
nCurvePoints = 500;  % number of points along fitted curve to use for max difference

% XfitData = zeros(1,2);
% YfitData = zeros(1, 2);
% PfitData = zeros(1, 2*length(P0));

% first, get test statistic from data (idealized sampling distribution)
lox = max(min(X{1}), min(X{2}));
hix = min(max(X{1}), max(X{2}));
XfitData{1} = linspace(lox, hix, nCurvePoints)';
for k = 1:2
    if isempty(P0)
        Pf{k} = [];
        Yf{k} = splineFunc(X{k}, Y{k}, XfitData{1});
    else
        Pf{k} = fminsearch(@(P) errFunc(P, X{k}, Y{k}, func), P0);
        Yf{k} = func(Pf{k}, XfitData{1});
    end
end
YfitData = {[Yf{1}, Yf{2}]};
PfitData = [Pf{1}, Pf{2}];
maxDdata = computeMaxD(YfitData{1});

% Now, bootstrap pairs to create the empirical sampling distribution
% under the Null Hypothesis, the two populations are
% interchangeable.
n = [];
n(1) = numel(X{1});
n(2) = numel(X{2});
maxD = zeros(nBoot, 1);

% merge the data points, because H0 assumes interchangeability
x = [X{1}; X{2}];
y = [Y{1}; Y{2}];
N = numel(x);

opts = optimset('fminsearch');
opts = optimset(opts, 'MaxFunEvals', 1e6, 'MaxIter', 1e6, 'TolFun', 1e-6, 'TolX', 1e-6, 'Display','off');

Xfit = cell(nBoot, 1);
Yfit = cell(nBoot, 1);
Pfit = zeros(nBoot, max(2, 2*length(P0)));

% FOR or PARFOR choice in code
% Choose "for" or "parfor" for the main loop
% by commenting out the appropriate line
% for nb = 1:nBoot
parfor nB = 1:nBoot
    ix = cell(2, 1);
    Xb = cell(2, 1);
    Yb = cell(2, 1);
    Yf = cell(2, 1);
    Pf = cell(2, 1);
    
    % resample x and y as a pair
    for k = 1:2
        ix{k} = randsample(N, n(k), replacement);
        Xb{k} = x(ix{k});
        Yb{k} = y(ix{k});
    end
    
    % Fit data with curve, with overlapping x-range
    lox = max(min(Xb{1}), min(Xb{2}));
    hix = min(max(Xb{1}), max(Xb{2}));
    Xfit{nB} = linspace(lox, hix, nCurvePoints)';
    
    % fit the curves
    for k = 1:2
        if isempty(P0)
            Yf{k} = splineFunc(Xb{k}, Yb{k}, Xfit{nB});
            Pf(k) = {0};
        else
            [Pf{k},fval,exitflag,output] = fminsearch(@(P) errFunc(P, Xb{k}, Yb{k}, func), P0, opts);
            Yf{k} = func(Pf{k}, Xfit{nB});
        end
    end
    Yfit{nB} = [Yf{1}, Yf{2}];
    Pfit(nB, :) = [Pf{1}, Pf{2}];
    maxD(nB) = computeMaxD(Yfit{nB});
end

% merge statistics
Pfit = cat(1, PfitData, Pfit);
Xfit = cat(1, XfitData, Xfit);
Yfit = cat(1, YfitData, Yfit);
allD = [maxDdata; maxD];
pvalue = getPvalue(allD);
hypoth = pvalue < 0.05;

% get param statistics
mnP = mean(Pfit);
alpha = 0.05;
alphao2 = alpha/2;
ciP = quantile(Pfit, [alphao2, 1-alphao2], 1);

% store in output variable
Pstats.data.D = maxDdata;
Pstats.data.P = PfitData;
Pstats.boot.D = allD;
Pstats.boot.P = P;
Pstats.boot.mnP = mnP;
Pstats.boot.ciP = ciP;
Pstats.boot.Xfit = Xfit;
Pstats.boot.Yfit = Yfit;

%% maxD = computeMaxD(Y) compute max difference between curves in cell array Y
function maxD = computeMaxD(Y)
maxD = max(abs(diff(Y, 1, 2)));

%% getPvalue(allD): get the Pvalue, based on a two-tailed test
function pvalue = getPvalue(allD)
maxDdata = allD(1);
nTot = numel(allD);
nLess = numel(find(allD < maxDdata)); % number below maxDdata

area = nLess / nTot;

md = median(allD);
if maxDdata > md    % use right tail
    pvalue = (1 - area);
else                % use left tail
    pvalue = area;
end
pvalue = 2 * pvalue;    % times 2 because for a two-tailed test

%% pltHisto(allD, pvalue): plot histogram
function pltHisto(allD, pvalue)
histogram_resamp(allD, 50)
hold on
ax = axis;
maxDdata = allD(1);
mnD = mean(allD);
h(1) = plot(mnD * [1, 1], [0, ax(4)], 'k', 'linewidth', 3);
h(2) = plot(maxDdata * [1, 1], [0, ax(4)], 'r', 'linewidth', 3);
legend(h, {'Mean Distance', 'Data Distance'}, 'location', 'NE');
textpercent(60, 60, sprintf('nBoot = %d', numel(allD) - 1));

% do two-sided test
alpha = 0.05;
if pvalue >= alpha
    str = 'Can Not ';
else
    str = '';
end
title(sprintf('%sReject Two Curves as Same, p = %5.3f', str, pvalue));

%% plot the curves
function pltCurves(X, Y)
clrs = [0.6, 0.6, 1; 0.6 1 0.6];

% % plot data curve first
% x = X{1};
% for k = 1:2
%     y = Y{k};
%     h = plot(x, y, 'color', clrs(k), 'linewidth', 2);
%     hold on
% end

% plot bootstraps
for nB = 1:length(X)
    x = X{nB};
    for k = 1:2
        y = Y{nB}(:, k);
        h = plot(x, y, 'color', clrs(k, :));
    end
end

%% function err = errFunc(P, X, Y, func)
function err = errFunc(P, X, Y, func)
pmax = max(abs(P));
if pmax > 1e3
    err = 1e8;
return
end

Yfit = func(P, X);
r = Y - Yfit;
err = r' * r;

%% function Yfit = splineFunc(X, Y, Xfit, lamda), spline fit function
% X, Y are the data inputs
% Xfit is a vector of x-values at which Yfit should be computed.
% smooth = a number in [0, 1] that controls how much smoothing
%   the spline does. Default = 1e-5, for very little smoothing. Larger
%   values do more smoothing.
function Yfit = splineFunc(X, Y, Xfit, smooth)
if nargin < 4
    smooth = 1e-5;
end
% be sure no repeated X values
k = diff(X);
kk = find(abs(k) < 1e-3);
epsi = 1e-3;
for j = 1:length(kk)
    X(kk(j)) = X(kk(j)) + j * epsi;
end

lambda = 1 - smooth;
% use smoothing spline from csaps
Yfit = csaps(X, Y, lambda,Xfit);


%% function dispPci(mnP, ciP) to display parameter fits
function dispPci(PfitData, mnP, ciP)
fprintf('Parameter values in Rows; Columns show mean of parameters and confidence intervals\n');
fprintf('Left half of columns are params from curve 1, right half of columns are from curve 2\n');
fprintf('First row is data fit, second row is mean of bootstrap, Third and Fourth rows are 95%% CI of mean\n');

if isempty(PfitData)
    return
end

rowlbls = [];
n = numel(PfitData)/2;
lbls = {'Same', 'Different'};
for k = 1:2
    for j = 1:n
        rowlbls{k+ 2*(j-1)} = sprintf('%s P_%d', lbls{j}, k);
    end
end

colLbls = {'dataMean', 'bootMean', 'CI_95_lo', 'CI_95_hi'};
T = table(PfitData', mnP', ciP(1,:)', ciP(2,:)', 'RowNames', rowlbls, 'VariableNames', colLbls);
T.Properties.Description = 'Parameters of Curve Fits';
fprintf('\n<strong>%s:</strong>\n', T.Properties.Description);
disp(T)

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% The following functions are used for self-testing the program. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% function Y = testFunc(P, X) : returns Y = f(P, X)
% used in test if no input
function Y = testFunc(P, X)
Y = X.*X + P(1) * cos(2*pi*P(2)*X);

%% Function to test bootTestCurvesSame(), when no inputs are given
function runTestFunction
% create two fake data sets, one with two curves that are
% the same, and one with two curves that are different.
% run test on both.
tic
doTestSpline = 0;   % 0 to use function, 1 to use splines

% first, test if same gives null hypothesis (same)
X = cell(2, 1);
Y = cell(2, 1);
Npoints(1) = 20;
Npoints(2) = 35;
P0 = [1, 1];

sigma = 0.31; % amount of noise on points %%%%%%%%%%%%%%%%%%%

for k = 1:2
    N = Npoints(k);
    x = (0:N)' / N + (k-1) * 0.05*randn;
    X{k} = x;
    Y{k} = testFunc(P0, X{k}) + rand(size(X{k}))*sigma;
end

figure(1)
clf
set(gcf, 'pos', [610         160        1233         913]);

subplot(2, 2, 1);  % same curves plots
hold on
if doTestSpline
    [hypoth, pvalue, Pstats] = bootTestCurvesSame(X, Y);
else
    [hypoth, pvalue, Pstats] = bootTestCurvesSame(X, Y, 2000, @testFunc, [0.5, 1.2]);
end
pltCurves(Pstats.boot.Xfit, Pstats.boot.Yfit);
title('Same Function');
xlim([0, 1]);
h = plot(X{1}, Y{1},'b.', X{2},Y{2}, 'g.', 'markersize', 15);
xlabel('X');
ylabel('Y');
textpercent(2, 97, 'bootTestCurvesSame -- LM Optican 26may2015');

subplot(2, 2, 3);   % same curves histo
pltHisto(Pstats.boot.D, pvalue);
drawnow
xlabel('Maximum Distance Between Curves');
ylabel('Number');
fprintf('\nTest Similar Curves: hypoth = %d, p-value = %8.3f\n', hypoth, pvalue);
dispPci(Pstats.data.P, Pstats.boot.mnP, Pstats.boot.ciP);

% Second, test if different rejects null hypothesis (i.e., not same)
subplot(2, 2, 2); % different curves
hold on
beta = 0.10; % fraction change in Y{2} %%%%%%%%%%%%%%%%%%%%%%%

Y{2} = testFunc( P0 * (1 + beta), X{2}) + rand(size(X{2}))*sigma;

if doTestSpline
    [hypoth, pvalue, Pstats] = bootTestCurvesSame(X, Y);
else
    [hypoth, pvalue, Pstats] = bootTestCurvesSame(X, Y, 2000, @testFunc, [0.5, 1.2]);
end

pltCurves(Pstats.boot.Xfit, Pstats.boot.Yfit);
h = plot(X{1}, Y{1},'b.', X{2}, Y{2}, 'g.', 'markersize', 15);
xlabel('X');
ylabel('Y');
title('Different Functions');
xlim([0, 1]);

subplot(2, 2, 4); % different histo
pltHisto(Pstats.boot.D, pvalue)
xlabel('Maximum Distance Between Curves');
ylabel('Number');

drawnow
fprintf('\nTest Different Curves: hypoth = %d, p-value = %5.3f\n', hypoth, pvalue);
dispPci(Pstats.data.P, Pstats.boot.mnP, Pstats.boot.ciP);
toc
