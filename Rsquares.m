% Rsquares: function to compute R-square and adjusted-R-Square
function [Rsquared, adjRsquared] = Rsquares(y, yhat, Np)
% Input:
%   y is the vector of data values
%   yhat is the vector of model fitted values
%   N is the number of parameters in the model
% Output:
%   Rsquared = coefficient of determination, indicates how well data fit
%       model. It is the ratio of variance explained by the model to the
%       total variance (sample variance of the dependent variable). It provides
%       a measure of how well observed outcomes are replicated
%       by the model, as the proportion of total variation of outcomes explained
%       by the model.
%   adjRsquared:  adjusted R^2, penalizes R^2 as extra variables are included
%       in the model. Used to compare nested models. adjRsquared can be < 0 or >
%       1.Adjusted R^2 does not have the same interpretation as R^2; whereas
%       R^2 is a measure of fit, adjusted R^2 is instead a comparative measure of
%       suitability of alternative nested sets of explanators.

ymn = mean(y);
SStot = sum((y - ymn).^2);
% SSreg = sum((yhat - ymn).^2);
SSres = sum((y - yhat).^2);

Rsquared = 1 - (SSres / SStot);

% disp(sprintf('Rsquared = %5.3f', Rsquared));

% get adjusted R-squared value based on nu = residual degrees of freedom
n = numel(y);
adjRsquared = 1 - ( (SSres * (n - 1)) / (SStot * (n - Np)) );
% disp(sprintf('adjRsquared = %5.3f', adjRsquared));