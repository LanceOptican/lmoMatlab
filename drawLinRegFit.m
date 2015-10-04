% fit a linear regression model, and draw best fit line
function [ht, hfit] = drawLinRegFit(x, y)
% mdl = fitlm(x, y);
% ci = coefCI(mdl,0.05);
% aRsquare = mdl.Rsquared.Adjusted;
% intcpt = mdl.Coefficients.Estimate(1);
% slope = mdl.Coefficients.Estimate(2);
% xnew = [min(x), max(x)];
% ypred = feval(mdl,xnew);
% 
% % 1-alpha confidence interval
% alpha = 0.05;
% ynew = min(x) + [0:100]/100 * (max(x)-min(x));
% [yc, yci] = predict(mdl, ynew', 'alpha', alpha);
% 
% 
% h = plot(xnew, ypred, 'k', 'linewidth', 2);
% hold on
% % plot(xnew', yc, 'r--');
% plot(ynew, yci(:,1), 'k--');
% plot(ynew, yci(:,2), 'k--');

% strip out any nans
k = find(isnan(y));
x(k) = [];
y(k) = [];

% Assure that the data are row vectors.
x = reshape(x,1,length(x));
y = reshape(y,1,length(y));

degree = 1;
alpha = 0.05;


[p, S] = polyfit(x, y, degree);
slope = p(1);
intcpt = p(2);
xfit = [min(x), max(x)];
yfit = polyval(p,xfit);
yf = polyval(p, x);

cfit = linspace(min(x), max(x), 200);
[yc, ci] = polyconf(p,cfit,S,'alpha',alpha,'predopt','curve', 'simopt', 'on'); % Add prediction intervals to the plot.

% get R^2 and adjusted-R^2
[Rsq, aRsq] = rsqArsq(y, yf, degree);

% draw it
hold on
hfit(1) = plot(xfit, yfit, 'k', 'linewidth', 2);
hfit(2) = plot(cfit,yc+ci,'k--');
hfit(3) = plot(cfit,yc-ci,'k--');

ax = axis;
ty = ax(3) + 0.01 * (ax(4) - ax(3));
tx = ax(2) - 0.01 * (ax(2) - ax(1));
ht = text(tx, ty, sprintf('y=%5.2fx+%5.2f, aR^2=%5.3f', slope, intcpt, aRsq));
set(ht, 'horizontalalignment', 'right', 'verticalalignment', 'bottom');

% test of rsquares func
% yhat = feval(mdl,x);
% [Rsquared, adjRsquared] = Rsquares(y, yhat, 2);
% ht = text(tx, ty-10, sprintf('aR^2=%5.3f', adjRsquare));