function ret = mapvec(command,vector)
% MAPVEC --- lambda-style functional programming construct
% ret = mapvec(command,vector)
% applies the command to each element of the vector, returning a 
% VECTOR
% command -- a lambda string taking one argument, e.g., size(#)
%            and returning a single numerical value.

% (c) 1998-9 by Daniel T. Kaplan, All Rights Reserved

ret = zeros(size(vector));
for k=1:length(vector)
  ret(k) = runlambda(command,vector(k) );
end


