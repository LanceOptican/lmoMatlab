function procedure = lambda(string)
% LAMBDA --- functional programming construct
% procedure = lambda(string)
% Take a string, parse it for the names of variables in the workspace,
% and return a procedure structure that contains the string
% with the values needed environmental variables saved
% One could also imagine writing a lambda that just saves the names
% of the variables and evaluates them at run time, but this would
% only work with the global environment

% (c) 1998-9 by Daniel T. Kaplan, All Rights Reserved
% Version 1.0

% get the names of the variables
s = evalin('caller','who(''*'')');

maxvars = 20;
% allow up to 20 variables in the environment
procedure = cell((maxvars+1),1);
% slot 1 will contain the string

% keep track of what variables have already been put in the
% environment
already = cell((maxvars+1),1);


%IMPORTANT: This definition must be repeated below in tokenreplace()
delimiters = [9:13 32 '`!$%^&*()-+={}[]:;''?/>.<,'];
%IMPORTANT: This definition must be repeated below in tokenreplace()

envcount = 1;
rem = string;
while length(rem) > 0
  [token,rem] = strtok(rem,delimiters);
  if doesitmatch(token,s)
    % replace the token with @#envcount#
    % and place the value of the variable that matched in the structure
    
    if ~doesitmatch(token,already)
      % increment first so that slot number 1 is reserved
      envcount = envcount+1;
      if envcount > (length(procedure))
        error('Too many variables handed to lambda.  Increase size of variable ''procedure''');
      end
      newname = sprintf('@@@%d@@@',envcount);
      string = tokenreplace(token,newname,string);
      % add the variable to the environment
      procedure{envcount} = evalin('caller',token); 
      already{envcount} = token; 
    end
  end
end

procedure{1} = string;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ret = doesitmatch(t,s)
% ret = doesitmatch(t,s)
% return 1 if t matches one of the strings in cell array s
ret = 0;
for k=1:length(s)
  if strcmp(t,s{k})
    ret = 1;
    return
  end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function newstring = tokenreplace(token,newname,string)

rem = string;
%IMPORTANT: This definition is repeated from above
delimiters = [9:13 32 '`!$%^&*()-+={}[]:;''?/>.<,'];
%IMPORTANT: This definition is repeated from above

while length(rem) > 0
[t,rem] = strtok(rem,delimiters);


if strcmp(token,t)
  ss = length(string) -(length(rem) + length(token));
  string = [string(1:ss) newname rem];
end
  
end

newstring = string;
