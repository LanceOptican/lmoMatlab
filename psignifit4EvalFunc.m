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

