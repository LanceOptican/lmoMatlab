function res = iqr(data)
% IQR(data) --- interquartile range

% (c) 1998-9 by Daniel T. Kaplan, All Rights Reserved
% Version 1.0

res = diff(percentile(data,[.25 .75]));
