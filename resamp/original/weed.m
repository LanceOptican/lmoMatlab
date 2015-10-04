function res = weed( data, test )
% WEED (data, test )
% Eliminates any values in <data> that passes the test
%
% Examples:
%   data = [1 2 3 4 5 6];
%   weed(data, data>3 ) ==>  [1 2 3]
%
%   weed(data, ismissing(data))
%
%   To eliminate values in multiple parallel data sets when there is a
%    missing value in any of the data sets
%   foo = ismissing(data1) | ismissing(data2) ...
%   data1 = weed(data1, foo);
%   data2 = weed(data2, foo); and so on.
 
% (c) 1998-9 by Daniel T. Kaplan, All Rights Reserved
% Version 1.0

if isnumeric(test)
  if length(test) ~= length(data)
     error('weed: <data> and <test> are not the same length.');
  end
  res = data( find(~test) );
else
  % handle the case of a lambda
  error('lambda is not yet implemented.')
end
