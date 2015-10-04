% Simulates many trials of flipping 100 coins

% we will represent the coin as 0 for heads, 1 for tails
coin = [0 1];
z = starttally;
for trials = 1:1000
  flips = sample(100,coin);
  nheads = count( flips == 0 );
  tally nheads z;
end

disp('Fraction of trials with 40 or fewer heads:')
proportion(z<=40)