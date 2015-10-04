function res = poll( rate, pollsize, conf )
% POLL( support, pollsize )
% Gives 95% confidence intervals on the level of yesses in a yes-no poll.
% rate    --- the fraction of yesses in the population (in percent, 
%             e.g., 8 means 8 percent.
% pollsize--- how many samples in the poll
%   It is assumed that the samples are independent and randomly chosen
% Optional third argument specifies the confidence interval, e.g.
% poll( 32, 2000, [.05 .95]) gives 90 percent confidence intervals in
% a poll of 2000.

% set the default confidence level for 95 percent
if nargin < 3
  conf = [.025 .975];
end

voters = [(1-rate) 0; rate 1];

Ntrials = 1000;

z = starttally;
for trials = 1:Ntrials
   poll = sample(pollsize, voters);
   support = count( poll == 1 )/pollsize;
   tally support z;
end

res = percentile(z, conf);
