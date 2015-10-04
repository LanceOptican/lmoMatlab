function res = expand(multiplicities)
% EXPAND(multiplicities) -- expands a set of multiplicities
% takes a 2-column matrix, interpreting the first column
% as integer multiplicies and the second value as the
% corresponding values
% a single row vector is returned, which has each of the
% values repeated according to it's corresponding multiplicities.
% Example:
% expand([1 1.1; 2 2.2; 3 3.3]) gives
% the row vector [1.1 2.2 2.2 3.3 3.3 3.3]'

% (c) 1998-9 by Daniel T. Kaplan, All Rights Reserved
% Version 1.0

[r,c] = size(multiplicities);
mults = multiplicities(:,1);
vals = multiplicities(:,2);


if c~= 2
   error('expand: argument must be a two-column matrix');
end
if any( mults ~= floor(mults)) | any(mults < 0)
   error('expand: first column of multiplicities must be positive integers.')
end

total = sum(mults);
res = [];
for k=1:length(mults)
   res = [res; vals(k)*ones(mults(k),1)];
end
