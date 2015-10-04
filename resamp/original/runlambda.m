function [r1,r2,r3,r4,r5] = runlambda(command,p1,p2,p3,p4,p5)
% RUNLAMBDA --- lambda-style functional programming construct
% [r1,r2,r3,r4,r5] = runlambda(command,p1,p2,p3,p4,p5)
% evaluate a command, substituting as appropriate for the variables
% named #1, #2, and so on.
%

% (c) 1998-9 by Daniel T. Kaplan, All Rights Reserved

if nargin < 6
  p5 = 0;
end
if nargin < 5
  p4 = 0;
end
if nargin < 4
  p3 = 0;
end
if nargin < 3
  p2 = 0;
end
if nargin < 2
  p1 = 0;
end
if nargin < 1
  error('runlambda requires a command string or structure.');
end


switch nargout
case 0,
 runlambdastring(command,p1,p2,p3,p4,p5);
case 1,
 r1 = runlambdastring(command,p1,p2,p3,p4,p5);
case 2,
 [r1,r2] = runlambdastring(command,p1,p2,p3,p4,p5);
case 3,
 [r1,r2,r3] = runlambdastring(command,p1,p2,p3,p4,p5);
case 4,
 [r1,r2,r3,r4] = runlambdastring(command,p1,p2,p3,p4,p5);
case 5,
 [r1,r2,r3,r4,r5] = runlambdastring(command,p1,p2,p3,p4,p5);
otherwise,
 error('Too many output arguments in runlambda');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [r1,r2,r3,r4,r5] = runlambdastring(command,p1,p2,p3,p4,p5)
% handle the case when command is a simple string
if iscell(command)
  string = command{1};
  string = strrep(string,'@@@','yqr');
  %assign the local variables to have the values given in the structure.
  yqr2yqr = command{2};
  yqr3yqr = command{3};
  yqr4yqr = command{4};
  yqr5yqr = command{5};
  yqr6yqr = command{6};
  yqr7yqr = command{7};
  yqr8yqr = command{8};
  yqr9yqr = command{9};
  yqr10yqr = command{10};
  yqr11yqr = command{11};
  yqr12yqr = command{12};
  yqr13yqr = command{13};
  yqr14yqr = command{14};
  yqr15yqr = command{15};
  yqr16yqr = command{16};
  yqr17yqr = command{17};
  yqr18yqr = command{18};
  yqr19yqr = command{19};
  yqr20yqr = command{20};
else
  % it's a string
  string = command;
  origstring = string;
end

for k=1:nargin
  tostr = sprintf('p%d',k);
  fromstr = sprintf('#%d',k);
  string = strrep(string,fromstr,tostr);
end
string = strrep(string,'#','p1');
r1 = 0; r2 = 0; r3 = 0; r4 = 0; r5 = 0;

%Look to see if there is any assignment to r1,
% If so then we need to watch out for the case
% r1 = eval(string); which will generate an error message.
% instead, we want simply to eval(string)
fooflag = length(findstr(string,'r1='));
fooflag = max(fooflag,length(findstr(string,'r1 =')));
fooflag = max(fooflag,length(findstr(string,'r1  =')));

if nargout < 2 & fooflag
    warning('runlambda: Don''t assign to r1 in your command if returning only a single value');
end




if nargout > 1
  eval(string);
elseif nargout == 1
  if fooflag 
    eval(string);
  else
    r1 = eval(string);
  end
else % nargout == 0
  eval(string)
end



for k=2:nargout
  checkstr = sprintf('r%d',k);
  if 0 == length(findstr(checkstr,string))
     errorstr = sprintf('runlambda: no assignment to r%d in command ''%s''\n           although there are %d output arguments called for.',k,origstring,nargout);
     warning(errorstr);
  end
end

  





