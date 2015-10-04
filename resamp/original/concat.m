function res = concat(a,b)
% CONCAT (a,b) --- concatenate two data sets

% (c) 1998-9 by Daniel T. Kaplan, All Rights Reserved
% Version 1.0

[ra,ca] = size(a);
[rb,cb] = size(b);

% if the data sets are vectors, concatenate them the long way
if (ra == 1 | ca == 1) & (rb == 1 | cb == 1 )
  if ca == 1
     % vector a is a column
     if cb == 1
        res = [a;b];
     else
	res = [a; b'];
     end
  else
     % vector a is a row
     if cb == 1
        res = [a, b'];
     else
        res = [a, b];
     end
  end
else
  % one of them is a matrix
  if ca == cb 
    res = [a;b];
  elseif ra == rb
    res = [a, b];
  elseif ra == cb
    res = [a, (b')];
  elseif ca == rb
    res = [a; (b')];
  else
    error('concat: data sets are not of compatible size');
  end
end
