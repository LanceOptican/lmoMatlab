function ret = map(command,vector)
% MAP --- lambda-style functional programming contruct
% ret = map(command,vector)
% applies the command to each element of the vector, returning a 
% cell array 
% command -- a lambda string taking one argument, e.g., size(#)

% (c) 1998-9 by Daniel T. Kaplan, All Rights Reserved
% Version 1.0

ret = cell(size(vector));
for k=1:length(vector)
  ret{k} = runlambda(command,vector(k) );
end


