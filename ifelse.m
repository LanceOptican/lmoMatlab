function ret = ifelse(cond,first,second)
% IFELSE --- lambda-style functional program construct
% ifelse(cond,first,second)
% mimicks the if else end control structure in Matlab

% (c) 1998-9 by Daniel T. Kaplan, All Rights Reserved
% Version 1.0
if cond
  ret = first;
else
  ret = second;
end
