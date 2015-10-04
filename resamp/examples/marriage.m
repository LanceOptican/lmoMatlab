husbands = [25 25 51 25 38 30 60 54 31 54 23 34 25 23 19 71 26 31 26 62 29 31 29 35];
wives =    [22 32 50 25 33 27 45 47 30 44 23 39 24 22 16 73 27 36 24 60 26 23 28 36];



% A bad way to do things
agediff = mean(wives) - mean(husbands)

nullhypothages = concat(husbands, wives);
z = starttally;
for trials = 1:1000
   wdata = sample( length(wives), nullhypothages);
   hdata = sample( length(husbands), nullhypothages);
   teststat = mean(wdata) - mean(hdata);
   tally teststat z;
end
display('Unpaired test p-value (two-tailed)')
leftextreme = agediff;
rightextreme = mean(z) + abs(mean(z) - agediff);
display(count( z<leftextreme | z>rightextreme)/length(z) )

% a better way to do things
 
% find the difference in age WITHIN each couple
agediffs = wives - husbands;
meandiff = mean(agediffs)

z = starttally;
for trials = 1:1000
  signs = sample(length(agediffs), [-1 1]);
  teststat = mean( signs .* agediffs );
  tally teststat z;
end

display('Paired test: p-value (two-tailed)')
leftextreme = agediff;
rightextreme = mean(z) + abs(mean(z) - agediff);
display(count( z<leftextreme | z>rightextreme)/length(z) )
