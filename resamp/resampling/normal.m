function res = normal(one,two,three)
% NORMAL --- probability distribution
% normal( n, mean, stddev )
% generates random numbers from a normal (gaussian) distribution
%
% normal( mean, stddev )
% creates an URN from which sampling can be done using SAMPLE

% (c) 1998-9 by Daniel T. Kaplan, All Rights Reserved
% Version 1.0
if nargin == 1 
    error('normal: invalid argument.  Must be normal(mean, stddev)');
elseif nargin == 2
  if isstruct(two)
    if isfield(two,'id') & strcmp(two.id,'urn') & strcmp(two.type, 'normal')
       res = normal(one, two.mean, two.stddev);
    else
       error('normal: Invalid object type.  Must be id == ''urn'' and type==''normal''.');
    end
  else
    % generate an URN
    res.id = 'urn';
    res.type = 'normal';
    res.mean = one;
    res.stddev = two;
    % when evaluating an urn, set <thisurn> to be the urn 
    % and  call eval(sprintf(res.generate, nsamps))
    res.generate = 'normal(%d, thisurn)';
  end
elseif nargin == 3
  n = one;
  mean = two;
  std = three;
  res = randn(n,1)*std + mean;
else
  error('normal: invalid number of arguments.');
end
  
