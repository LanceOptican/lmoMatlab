function res = shuttle(hypothrate, nflights, naccidents)
% shuttle(truerate,nflights, naccidents)
% compute the probability that <naccidents>
% or fewer  
% will be seen in <nflights> flights if the 
% hypothesized accident rate is <hypothrate>
% Returns two numbers:
% -- the probability of seeing naccidents or fewer
% -- the probability of seeing naccidents or greater.
data = [(1-hypothrate) 0; hypothrate 1];
z = starttally;
for trials = 1:5000
   % simulate nflights
   s = sample(nflights, data); 
   % count how many crashes
   crash = count(s==1);
   tally crash z;
end
res = [proportion(z<=naccidents), proportion(z>=naccidents)];
