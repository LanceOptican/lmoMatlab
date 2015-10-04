% [Rsq, aRsq] = rsqArsq(y, yf, degree)
% Compute R-square and adjusted R-square values
% of yf fit to y, using polynomial degree
% LMO 7apr2014 Create
function [Rsq, aRsq] = rsqArsq(y, yf, degree)
N = length(y);
resid = y - yf;
SSresid = sum(resid.^2);
SStotal = (length(y) - 1) * var(y);
Rsq = 1 - SSresid / SStotal;
aRsq = 1 - (SSresid / SStotal)*((N-1)/(N-degree-1));
