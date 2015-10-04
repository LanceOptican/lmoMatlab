function res = exponential( one, two )
% EXPONENTIAL(n,mean) --- probability distribution
% generates exponentially distributed random numbers 
% with the specified mean
%
% exponential( mean )
% creates an URN from which sampling can be done using SAMPLE

% (c) 1998-9 by Daniel T. Kaplan, All Rights Reserved

if nargin == 2
   if isstruct(two)
      if isfield(two,'id') & strcmp(two.id,'urn') & strcmp(two.type, 'exponential')
         res = exponential(one, two.mean);
      else
         error('uniform: Invalid object type.  Must be id == ''urn'' and type==''uniform''.');
      end
   else
      res = -two*log(uniform(one,0,1));
      return;
   end    
elseif nargin == 1
    % generate an URN
    res.id = 'urn';
    res.type = 'exponential';
    res.mean = one;
    % when evaluating an urn, set <thisurn> to be the urn 
    % and  call eval(sprintf(res.generate, nsamps))
    res.generate = 'exponential(%d, thisurn)';
else
     error('uniform: invalid number of arguments.');
end
  
