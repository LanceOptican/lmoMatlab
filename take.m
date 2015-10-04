function res = take(data,pos)
% TAKE(data,pos)
% pulls out the values in data at the given positions
% e.g. take( x, 3:10 )
% pulls out the third through 10th values of x
%
% Experienced Matlab programmers will prefer to use
% the native indexing operations, e.g., x(pos)

% (c) 1998-9 by Daniel T. Kaplan, All Rights Reserved
[r,c] = size(pos);
if r>1 & c>1
   error('Take works only with vectors of integers for positions');
end 

[r,c] = size(data);
if r>1 & c>1
   error('Take works only with vectors for data');
end 




pos = ceil(pos);
if max(pos) > length(data) | min(pos) < 1
   error('pos must be integers 1 through length of data');
end

res = data(pos);