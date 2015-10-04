% simulate 15 studies, for each of which the
% null hypothesis is true.  Find the probability
% of observing one p-value < 0.03 and another < .04
% (one-tailed p-values) and that
% none of the 15 studies have a p-value > .95


z = starttally;
for trials = 1:1000
   pvalues = uniform(15,0,1);
   %sort from smallest to largest
   pvalues = sort(pvalues);
   goodenough = pvalues(1) < .03 & pvalues(2) < .04 & pvalues(length(pvalues))<.95;
   tally goodenough z;
end
proportion(z)