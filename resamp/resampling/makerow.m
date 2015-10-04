function res = makerow(vector)
% MAKEROW --- puts a vector in row form
% makerow(vector)
% returns vector in the form of a row vector
% vector must be 1xn or nx1

% (c) 1998-9 by Daniel T. Kaplan, All Rights Reserved
% Version 1.0

[r,c] = size(vector);
if r == 1 
   res = vector;
elseif c == 1
   res = vector';
else 
   res = vector;
   warning('makerow: Invalid argument.  Not a vector.')
end
