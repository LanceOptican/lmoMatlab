function res = variance(data)
% VARIANCE(data)
% take the variance of data, using N-1 as the denominator
% See also, STD for the standard deviation

% (c) 1998-9 by Daniel T. Kaplan, All Rights Reserved
% Version 1.0

res = std(data);
res = res.*res;
