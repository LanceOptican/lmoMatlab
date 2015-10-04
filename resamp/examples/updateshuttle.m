function posterior = updateshuttle(prior, crash)
% posterior = updateshuttle(prior, crash)
% translate a prior accident rate into a posterior
% prior -- the prior probability distribution of an accident rate
% crash -- 0 if there was no crash, 1 otherwise.
% The posterior takes the form of a list of accident rates.

Ntrials = 1000;
posterior = starttally;
for trial = 1:Ntrials
   rate = sample(1, prior);
   thisflight = sample(1, [(1-rate) 0; rate 1]);
   % 0 means no accident, 1 == accident
   if thisflight == crash % the observation matches the simulation
      posterior = [posterior rate]; %or: tally rate posterior;
   end
end
