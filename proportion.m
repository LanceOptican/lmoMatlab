function res = proportion(data,test)
% PROPORTION --- finds proportion of data satisfying a test
% proportion(data,test) or
% proportion(data)
% returns the proportion of the data that satisfy the test
% See COUNT

% (c) 1998-9 by Daniel T. Kaplan, All Rights Reserved
% Version 1.0
if nargin < 2
   res = count(data);
else
   res = count(data,test);
end

res = res/length(data);
