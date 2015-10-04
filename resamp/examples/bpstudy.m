function pvalue = bpstudy(N)
% bpstudy(N)
% simulate the blood pressure study with 
% N subjects receiving the drug and
% N subjects receiving the placebo.
% the returned value is the p-value of the
% difference.

% generate data for the placebo group
placebo = normal(N, -4, 21); 
% and for the drug group
drug = normal(N, -14, 21);

% Now compute the p-value of the difference between the two groups
% Use a permutation test

observedval = mean(drug) - mean(placebo);

z = starttally;
nulldata = concat(placebo, drug);
for trials = 1:100
  pinds = 1:length(placebo);
  newdata = shuffle(nulldata);
  sampplacebo = newdata(pinds);
  sampdrug = exclude(newdata, pinds);
  teststat = mean(sampdrug) - mean(sampplacebo);
  tally teststat z;
end

% The observed difference in means is expected to be < 0.
% So we'll look for trials where z is even more negative.
pvalue = proportion(z < observedval);
