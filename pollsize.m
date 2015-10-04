function [thresh, type2rate] = pollsize(samplesize)
% Find the rejection threshold and Type II error rate
% of a test statistic which is the difference between
% successive polls.

backgroundsupport = 0.10;
nullincrease = 0.01;
alternativeincrease = 0.03;
significancelevel = 0.10;

z = starttally;
Ntrials = 1000;
for trials = 1:Ntrials
   % simulate the difference of two polls under the null.
   poll1 = sample(samplesize, [backgroundsupport 1; (1-backgroundsupport) 0]);
   poll2rate = backgroundsupport + nullincrease;
   poll2 = sample(samplesize, [poll2rate 1; (1-poll2rate) 0]);
   teststat = (count(poll2==1) - count(poll1==1))/samplesize;
   tally teststat z;
end
% compute the rejection threshold you'd have to use to make a 
% mistake at the specified significance level
% since we are testing only for an increase in support, we look
% at the right side of the distribution of z
thresh = percentile(z,1-significancelevel);

% Using the threshold, compute the Type II error rate under the
% alternative hypothesis.
z2 = starttally;
for trials = 1:Ntrials
   poll1 = sample(samplesize, [backgroundsupport 1; (1-backgroundsupport) 0]);
   poll2rate = backgroundsupport + alternativeincrease;
   poll2 = sample(samplesize, [poll2rate 1; (1-poll2rate) 0]);   
   teststat = (count(poll2==1) - count(poll1==1))/samplesize;
   tally teststat z2;
end
type2rate = count(z2<thresh)/length(z2);  
   
   