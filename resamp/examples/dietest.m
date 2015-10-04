% compare expected to observed frequencies for
% a simulated roll of the dice.

z = starttally;
Ntrials = 100;
expected = [1000; 1000; 1000; 1000; 1000; 1000];
for trials = 1:Ntrials
   rolls = sample(6000, [1 2 3 4 5 6]);
   observed = multiples(rolls);
   % sum of absolute deviations
   % teststat = sum( abs( observed - expected ));
   % for chi-squared
   teststat = sum( ((observed-expected).^2)./expected);
   tally teststat z;
end

result = count(z > 7.7)/length(z)
   