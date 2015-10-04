function res = corr(x,y)
% CORR (x, y) --- correlation coefficient
% compute the correlation coefficient between x and y

% (c) 1998-9 by Daniel T. Kaplan, All Rights Reserved
% Version 1.0

if length(x) ~= length(y)
  error('corr: arguments do not have the same length.');
end

foo = std(x)*std(y);
if foo == 0
  warning('corr: all data points identical.  NaN returned.');
  res = NaN;
else
  res=(sum( (x-mean(x)).*(y-mean(y)) )/foo)/(length(x)-1);
end
