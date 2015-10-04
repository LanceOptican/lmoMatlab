function tally(newvalue, resultvar)
% TALLY newvalue, resultvar
% keeps track of a value in a tally variable
% resultvar -- a tally variable created using starttally
% newvalue  -- the new value to keep track of
% MUST BE CALLED WITHOUT PARENTHESIS, as in
% tally newvalue resultvar
% where newvalue is the name of a variable containing
% the new value
% AN EXAMPLE
% z = starttally;
% for k=1:10
%   a = mean(rand(10,1));
%   tally a z
% end
%
% The first argument to tally can be a function call ONLY IF
% it is enclosed in quotations or is a single string, for instance
% z = starttally;
% for k=1:10
%   tally 'sin(k)' z
% end
%
% MATLAB experts:
% It's much faster to do this as follows:
% z = [];
% for k=1:10
%    a = mean(rand(10,1));
%    z = [z;a];
% end

% (c) 1998-9 by Daniel T. Kaplan, All Rights Reserved
% Version 1.0

if ~ischar(newvalue)
   error( 'TALLY should be called without parentheses.  For instance: tally b z');
end

   
% check to make sure that resultvar is a named variable in
% the calling namespace
if 0 == length(evalin('caller', sprintf('who(''%s'')',resultvar) ) )
   error( sprintf('Variable %s must be initialized using startscore', resultvar));
end


str = sprintf('%s = [ %s; %s ];', resultvar, resultvar, newvalue);

evalin('caller', str)
