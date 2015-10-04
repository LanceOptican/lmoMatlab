function res = confintervals(data, stat, conflevel)
% CONFINTERVALS -- computes confidence intervals using resampling
% res = confintervals(data, stat, conflevel)
% Compute confidence intervals of a given statistic using
% resampling
% e.g. confintervals(mydata, 'mean(#)', .95);

% (c) 1998-9 by Daniel T. Kaplan, All Rights Reserved

ntrials = 500;
if conflevel >= .90
   ntrials = 1000;
elseif conflevel >=.96
   ntrials = 2000;
elseif conflevel >=.98
   ntrials = 5000;
elseif conflevel > 1.0
   error('confintervals: conflevel is set > 1.0');
end

z = zeros(ntrials,1);
for trial = 1:ntrials
   newdat = sample(length(data), data);
   r1 = runlambda(stat, newdat);
   z(trial) = r1;
end
res = percentile(z,[(1-conflevel)/2, 1-(1-conflevel)/2]);