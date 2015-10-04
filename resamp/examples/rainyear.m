dailyrain = [80 0; 10 .25; 5 .5; 5 1];
z = starttally;
for trials = 1:1000
   annualrain = sum( sample(365, dailyrain) );
   tally annualrain z;
end
