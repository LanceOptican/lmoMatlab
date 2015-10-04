function [params, const, r2, resids] = regression(y,x)
% REGRESSION --- linear regression, multiple regression
% [params, const, r2, resids] = regression(y, x)
% Performs a linear regression of the 
% dependent variable y
% on the independent variable x
% x can be a matrix, with one column for each variable.
% x and y should have the same number of rows
% Outputs:
% params  : a vector of slopes, with one value for each column of x
% const   : the constant term of the linear equation
% r2      : r-squared for the fit
% resids  : the residuals from the fit

% (c) 1998-9 by Daniel T. Kaplan, All Rights Reserved
% Version 1.0

% make sure that x and y are compatible in size
[r,c] = size(y);
if c ~= 1
   error('regression: y must be a column');
end
[r2,c2] = size(x);
if r ~= r2
   error('regression: x and y must have the same number of rows.');
end
w = ones(r2,1);
x = [x,w];


% The least squares fit
rawparams = x\y;
const = rawparams(c2+1);
params = rawparams(1:c2);
yhat = x*rawparams;
resids = y - yhat;
r2 = (norm(yhat-mean(yhat))/norm(y-mean(y))).^2;


