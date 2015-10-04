function res = setmissing(data, codeval)
% SETMISSING(data, codeval)
% When reading in external data where missing data is represented
% by a codeval, this function allows you to convert to the internal 
% format where missing data is represented by NaN

% (c) 1998-9 by Daniel T. Kaplan, All Rights Reserved
% Version 1.0

res = data;
[r,c] = size(data);
if r==1 | c == 1
  x = find(data==codeval);
  res(x) = NaN;
else
  [x,y] = find( data == codeval);
  for k=1:length(x)
    res(x(k),y(k)) = NaN;
  end
end

