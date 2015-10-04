% Simulate the throwing of two dice, and find the probabilities
% of the sum of the faces.
die = [1 2 3 4 5 6];
% a fair dice, with equal probabilities of each face
results = starttally;
% tell MATLAB to start keeping score

Ntrials = 1000; % conduct 1000 trials

for trials = 1:Ntrials
  dicesum = sample(1,die) + sample(1,die);
  tally dicesum results;
end

% Count how many of each sum there are
[cnts, vals] = multiples(results);

% print the results
disp('probability  sumOfDice')
[cnts/Ntrials, vals]

hist(results,100);
% make a histogram of the results.
