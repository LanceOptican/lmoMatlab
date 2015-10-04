function res = birthday( groupsize, cliquesize )
% BIRTHDAY --- gives the probability of more than one person in a 
% group having the same birthday.
% birthday( groupsize, cliquesize )
% groupsize  -- size of the group
% cliquesize -- how many people have the same birthday
% example: birthday(30,2) 
% gives the probability that 2 or more people have the same birthday in 
% a group of 25

z = starttally;
for trials = 1:1000
  d = sample(groupsize, 1:365 );
  f = any( multiples(d) >= cliquesize);
  tally f z;
end

res = proportion(z);
