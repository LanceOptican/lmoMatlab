% HELP in porting from psignifit3 to psignifit4
% 17jun2015 LM Optican Created help file
% First, download the zip file (button on lower right) from "https://github.com/wichmann-lab/psignifit"
% Unzip the file, and put it in your matlab directory. Add the path to your startup.m file.
% example:
% addpath('psignifit4')
%
% Exploring:
% in the psignifit4 directory there are files "demo0XX.m" that tell you how
% to run the programs. You can play with these.
%
% Next, copy this script and add to your directory.
% This script enables you to evaluate the fitted function (e.g., for plotting) (it is the function that is missing!)
% ==========================================================================

% evaluate function in psignifit4
% INPUT:
%     result = structure from the psignifit(data,options) call
% OUTPUT:
%     X.x = x-values
%     X.xLow = x for low values
%     X.xHigh = x for high values
%     Y.y = fitted function
%     Y.yLow = fit to low values
%     Y.yHigh = fit for high values
%
% 17jun2015 LM Optican Create from pieces in plot program

function [X, Y] = psignifit4EvalFunc(result)

plotOptions = struct;
plotOptions.extrapolLength = 0.2;

if isnan(result.Fit(4)), result.Fit(4)=result.Fit(3);    end

if isempty(result.data)
    return
end

switch result.options.expType
    case {'nAFC'}
        ymin = 1./result.options.expN;
        ymin = min(ymin,min(result.data(:,2)./result.data(:,3)));
    otherwise
        ymin = 0;
end

if result.options.logspace
    xlength   = log(max(result.data(:,1)))-log(min(result.data(:,1)));
    x         = exp(linspace(log(min(result.data(:,1))),log(max(result.data(:,1))),1000));
    xLow      = exp(linspace(log(min(result.data(:,1)))-plotOptions.extrapolLength*xlength,log(min(result.data(:,1))),100));
    xHigh     = exp(linspace(log(max(result.data(:,1))),log(max(result.data(:,1)))+plotOptions.extrapolLength*xlength,100));
else
    xlength   = max(result.data(:,1))-min(result.data(:,1));
    x         = linspace(min(result.data(:,1)),max(result.data(:,1)),1000);
    xLow      = linspace(min(result.data(:,1))-plotOptions.extrapolLength*xlength,min(result.data(:,1)),100);
    xHigh     = linspace(max(result.data(:,1)),max(result.data(:,1))+plotOptions.extrapolLength*xlength,100);
end
fitValuesLow    = (1-result.Fit(3)-result.Fit(4))*arrayfun(@(x) result.options.sigmoidHandle(x,result.Fit(1),result.Fit(2)),xLow)+result.Fit(4);
fitValuesHigh   = (1-result.Fit(3)-result.Fit(4))*arrayfun(@(x) result.options.sigmoidHandle(x,result.Fit(1),result.Fit(2)),xHigh)+result.Fit(4);
fitValues = (1-result.Fit(3)-result.Fit(4))*arrayfun(@(x) result.options.sigmoidHandle(x,result.Fit(1),result.Fit(2)),x)+result.Fit(4);

X.x = x;
X.xLow = xLow;
X.xHigh = xHigh;
Y.y = fitValues;
Y.yLow = fitValuesLow;
Y.yHigh = fitValuesHigh;

%===========================================================
% To port from psignfit 3 to 4, you must make two changes: The callling sequence is different,
% and the evaluation sequence % is different.
% Note: demo_001.m runs a simple example.
%===========================================================
% Calling sequence example:
usePsignifit4 = 1; % set to 0 for psignifig3

if usePsignifit4 % use ver 4 -- The possible options are listed in demo_005.m, the priors are explained in demo_003.m
    options = struct;   % initialize as an empty struct
    options.sigmoidName     = 'tdist';   % choose cauchy as sigmoid
    options.expType         = 'YesNo';   % choose yes/no as the paradigm of the experiment
    options.estimateType    = 'mean';
    options.confP           = 0.95;
    options.CImethod        ='percentiles';
    
    warning('off','psignifit:pooling'); % If your data are blocked, this prevents a warning message
    resBig = psignifit(data,options);      % structure "res" is explained in demo_006.m
    res = rmfield(resBig,{'Posterior','weight'}); %  drop the Posterior from the result
    P = res.Fit;    % recover parameters of fit = [threshold,width,lambda,gamma,sigma]
else % use ver 3
    priors = struct;
    priors.m_or_a = 'Gauss(0, 300)'; % threshold
    priors.w_or_b = 'Gauss(50, 50)';  % width
    
    % Beta(a, b)
    % first shape parameter a = 1
    % if second shape parameter is small, the function is wide and uninformative
    % the larger b, the more informative the prior (large b pushes pdf toward 0);
    priors.lambda = 'Beta(1, 20)'; % lapse or miss rate -- for beta(), larger scale forces lambda toward zero
    priors.gamma  = 'Beta(1, 20)'; % guessing rate
    
    infer = BayesInference(data, priors, 'nafc', 1, 'sigmoid', sigmoid, 'core', core, 'cuts', [0.5]);
    P = infer.params_estimate;  % parameters of fit
end

%===========================================================
% to evaluate the function, e.g., for drawing,
if usePsignifit4 % use ver 4
    [Xfit, Yfit] = psignifit4EvalFunc(res); % this returns the X-range automatically
    X = Xfit.x;
    predicted = Yfit.y;
    plot(X, predicted);
else  % use ver3
    % initializations for plot
    X = [[-500:0.5:0], [0.1:0.1:200], [200.5:.5:500]]; % set up your own range for plotting Y vs. X
    predicted = evaluate(X, infer);
    plot(X, predicted);
end

%===========================================================
% Good Luck!


