function res = urn(varargin)
% URN( prob1, value, prob2, value2, ...)
% collects the possible outcomes and relative probabilities for use in SAMPLE
%
% Each of the values can themselves be an URN, or a vector or matrix.
% See NORMAL, UNIFORM, ... for examples of how to create simple urns. 
% See SAMPLE for how to use vectors and matrices for representing probabilities. 
% 
% Examples:
% ex1 = urn( .5, [0 1], .5, [1 2 3 4 5 6]);
% This simulates either flipping a coin or rolling a die
%
% ex2 = urn( .25, ex1, .75, normal(10,1) );
% With prob. 1/4, flip a coin or roll a die.  Otherwise, generate a normally
%  distributed random variable with mean 10 and std. 1
%  note that the urn form of normal() is being used.
%
% ex3 = urn( .1, normal(10,1), .2, normal(20,2), .7, uniform(4,6));
% sample from either of the normal distributions or the uniform distribution.

% (c) 1998-9 by Daniel T. Kaplan, All Rights Reserved
% Version 1.0

if length(varargin) == 1
  % Chances are that the user just handed off an atomic urn or a matrix
  % by mistake.
  disp('URN: use URN only for compound probability distributions');
  res = varargin{1};
else
  if mod(length(varargin),2) ~= 0
     error('URN: Uneven number of arguments.  Must specify probability and outcome for each outcome.')
  else 
     res.id = 'urn';
     res.type = 'compound';
     N = length(varargin)/2;
     res.probs = zeros(N,1);
     res.outcomes = cell(N,1);
     for k=0:(N-1)
        res.probs(k+1) = varargin{2*k+1};
        res.outcomes{k+1} = varargin{2*k+2};
     end
  end
end
