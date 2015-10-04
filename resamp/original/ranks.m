function res = ranks(data)
% RANKS(data) finds the ranks of the data
% identical values are all given the same rank, which
% is the mean of the ranks that would have been assigned
% to those values if "naive" ranks were given.

% Copyright (c) 1998-9 by Daniel T. Kaplan, All Rights Reserved.
% Version 1.0

[s,i] = sort(data);
% make the ranks in the same shape as the original
res = zeros(size(data));
res(1:length(data)) = (1:length(data));
% the naive ranks
res(i) = res;

% now correct for multiples
[ms,vals] = multiples(data);

for k=1:length(vals)
   if ms(k) > 1
      goo = find(data == vals(k));
      foo = res(goo);
      res(goo) = 0*goo + mean(foo);
   end
end

   
   
