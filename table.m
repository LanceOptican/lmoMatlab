function res = table(command,var1,var2)
% TABLE --- constructs a table of values of a command
% res = table(command, var )
% executes "command" for each of the values in vector var
% "command" must return a numerical value
% the variable #1 is set successively to these values
%
%
% res = table(command, var1,var2 )
% executes "command" for each of the values in vector var1 and var2
% #1 is set to the value of var1 and
% #2 is set to the value of var2

% (c) 1998-9 by Daniel T. Kaplan, All Rights Reserved
% Version 1.0

if nargin < 3
  res = zeros(length(var1),1);
  for k=1:length(var1)
    res(k) = runlambda(command,var1(k));
  end
else
  res = zeros(length(var1), length(var2));
  for x = 1:length(var1)
   for y = 1:length(var2)
     res(x,y) = runlambda(command, var1(x), var2(y));
   end
  end
end

