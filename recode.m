function res = recode( data, test, result )
% RECODE ( data, test, result ) 
% Changes any value in <data> that passes the <test> to the given <result>
% Other values are returned unchanged.
%
% Examples: 
%   data = [1 2 3 4 5 6]; 
%   data2 = recode(data, data<=3, 0)
%   with results:
%   data2 = 
%          [0 0 0 4 5 6]
%   data  = 
%           [1 2 3 4 5 6]  --- the input is unchanged
%   BUT: data = recode(data, data<=3, 0)
%        does change the data.
%
%   Recode missing data as 0s
%   data = recode( data, ismissing(data), 0 );
%   
%   
%
%   recode can also be used with lambda functions, for example
%   recode( data, lambda('between(#, 3, 5)'), 0 )

% (c) 1998-9 by Daniel T. Kaplan, All Rights Reserved
% Version 1.0


if isnumeric(test)
  if length(test) ~= length(data)
     error('recode: <data> and <test> are not the same length.');
  end
  res = data;
  res( find(test) ) = result;
else
  % handle the case of a lambda
  error('lambda is not yet implemented.')
end


