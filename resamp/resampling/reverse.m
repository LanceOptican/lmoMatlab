function res = reverse(data)
% REVERSE --- reverses a vector or matrix
%
% Reverse the order of a vector.
% If it is a matrix, flipud is applied.

% (c) 1998-9 by Daniel T. Kaplan, All Rights Reserved
% Version 1.0
[r,c] = size(data);
if r == 1
  res = fliplr(data);
else
  res = flipud(data);
end
