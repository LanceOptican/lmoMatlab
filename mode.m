function res = mode(data)
% MODE (data) 
% find the most common value in the data
% If there are ties, the smallest value is returned

% (c) 1998-9 by Daniel T. Kaplan, All Rights Reserved
% Version 1.0

[cnt,val] = multiples(data);
foo = max(cnt);
inds = find(foo == cnt);
foo = val(inds);
res = min(foo);
