function res = twoway(mat)
% TWOWAY(mat)
% compute an expected set of frequencies
% for a two-way table assuming that the two
% factors are independent.
% This is the outer product of the marginal probabilities times
% the total number of observations.
% The entries in the table should be counts, i.e., non-negative numbers

% (c) 1998-9 by Daniel T. Kaplan, All Rights Reserved
% Version 1.0

vert  = sum(mat,1);
horiz = sum(mat,2);
total = sum(vert);
vert = vert./total;
horiz = horiz./total;

res = [];
for k = horiz
   res = [res k*vert];
end
res = res.*total;
