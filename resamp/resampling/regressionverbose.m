function [paramss, const, r2, resids] = regressionverbose(y,x)
% REGRESSIONVERBOSE --- regression with printed diagnostics
%
% [params, const, stats] = regressionverbose(y,x)
% Carries out a regression of the
% dependent variable y
% on the independent variable x
% using the function regression, but
% printing out various diagnostic messages.

% (c) 1998-9 by Daniel T. Kaplan, All Rights Reserved

[params, const, r2, resids] = regression(y,x);

disp('Regression is:');
disp(['const = ',num2str(const)]);
for k=1:length(params)
   disp( ['parameter ', num2str(k), ' = ', num2str(params(k)) ]);
end

disp(['R-squared is ', num2str(r2)]);

if nargout > 0
   paramss = params;
end
