function res = count(vec, test)
% COUNT -- counts number of non-zero entries
%
% count(vec) counts the number of non-zero entries in vec
% See also: proportion
%
% EXAMPLES
% count( x > 10 )
% is the number of instances with x > 10
% 
% count( between(x,7,9)) 
% number of cases where x is between 7 and 9 (inclusive)
% 
% COUNT (vec, test) counts the number of times the data in vec 
% satisfies the test
% For more complicated tests, a lambda expression can be
% given as the second argument.  (See lambda.)
% count( x, 'sin(#) < cos(#)')
% but usually this is unnecessary.  For instance, the
% above can be written simply
% count( sin(x) < cos(x) )


% (c) 1998-9 by Daniel T. Kaplan, All Rights Reserved
% Version 1.0

if nargin < 2
   res = sum(vec ~= 0);
else
   if iscell(test) | ischar(test)
      res = count( mapvec( test, vec ) );
   else
      error('test must be a character string (or lambda) in count');
   end
end
