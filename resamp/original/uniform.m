function res = uniform( one, two, three )
% UNIFORM( n, lower, upper) --- probability distribution
% generates uniform random numbers in the range lower to upper
%
% uniform( lower, upper )
% creates an URN from which sampling can be done using SAMPLE

% (c) 1998-9 by Daniel T. Kaplan, All Rights Reserved
% Version 1.0
if nargin == 1 
    error('uniform: invalid argument.  Must be uniform(lower, upper)');
elseif nargin == 2
  if isstruct(two)
    if isfield(two,'id') & strcmp(two.id,'urn') & strcmp(two.type, 'uniform')
       res = uniform(one, two.lower, two.upper);
    else
       error('uniform: Invalid object type.  Must be id == ''urn'' and type==''uniform''.');
    end
  else
    % generate an URN
    res.id = 'urn';
    res.type = 'uniform';
    res.lower = one;
    res.upper = two;
    % when evaluating an urn, set <thisurn> to be the urn 
    % and  call eval(sprintf(res.generate, nsamps))
    res.generate = 'uniform(%d, thisurn)';
  end
elseif nargin == 3
  n = one;
  lower = two;
  upper = three;
  res = rand(n,1)*(upper-lower) + lower;
else
  error('uniform: invalid number of arguments.');
end
  
