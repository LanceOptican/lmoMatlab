function ranges = jab(data,statistic)
% JAB --- jackknife-after-bootstrap
% ranges = jab(data, statistic )
% carry out the jackknife-after-bootstrap computation 
% of whether you have enough data
% data -- your data set
% statistic -- your statistic based on resampling
%           -- this should be the name of a procedure in quotes
%           -- example: jab(data, 'conf95')
%           -- this procedure should return a scalar or row vector
% The result:
%   ranges gives an approximate 95\% confidence interval for
%   each of the quantities produced by 'statistic'
%   The max and min of this interval is given in a single row,
%   one row for each of the quantities.

% (c) 1998-9 by Daniel T. Kaplan, All Rights Reserved
% Version 1.0

if length(data) <= 1
   error('Data must have more than one value');
else
   res = runlambda(statistic, exclude(data,1));
   res = makerow(res); 
end

for k=2:length(data)
   ndata = exclude(data,k);
   resk = runlambda(statistic, ndata);
   res = [res; makerow(resk)];
end

[r,c] = size(res);
ranges = zeros(c,2);
factor = (length(data)-1)/length(data);
for k=1:c
   stderror = sqrt(factor) * std( res(:,k) );
   mn = mean( res(:,k) );
   ranges(k,1) = mn - 2*stderror;
   ranges(k,2) = mn + 2*stderror;
end
