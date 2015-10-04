function [cnt,val] = multiples(data, values)
% MULTIPLES(data) - counts how many times each value appears
%
% MULTIPLES(data, values) 
% counts how many times each of the specified values appears
% in the data set.
%
% Examples:
% multiples([1 2 3 1 1 1 2 3]) ->  4 2 2
%
% Count how many times each of the numbers 0 to 5
% appears in the data set
% multiples([1 2 3 1 1 1 2 3], [0 1 2 3 4 5]) -> 0 4 2 2 0 0
%
% [cnt, val] = MULTIPLES(data)
% Gives the values that appear multiply

% (c) 1998-9 by Daniel T. Kaplan, All Rights Reserved
% Version 1.0
if nargin == 2
   val = makerow(values)';
	cnt = 0*val;
   for k=1:length(val)
      cnt(k) = count(data == val(k));
   end
   
   return;   
end

d = sort(data);
c = diff(d);
res = [];
vals = [];
lastrun = 1;
for k=1:length(c)
   if c(k) ~= 0
      res = [res; lastrun];
      vals = [vals; d(k)];
      
      lastrun = 1;
   else
      lastrun = 1+lastrun;
   end
   
end 

res = [res; lastrun];
vals = [vals; d(length(d))];

cnt = res;
if nargout > 1
   val = vals;
end

