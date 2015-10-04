function fracinside = howmany(nsamps, conf,ntrials)
% fracinside = howmany(nsamps, conf)
% nsamps - number of samples to generate
% conf   - the confidence level, e.g. .95
% simulates how often the confidence interval
% contains the true mean in a simulation 
% from a normal distribution (variance 1)
nruns = 1000;
res = zeros(nruns,length(conf));
fractinside = zeros(length(conf),1);
for runs = 1:nruns
   data = normal(nsamps, 0, 1);
   % get the confidence interval
   z = zeros(ntrials,1);
   for trials = 1:ntrials
      z(trials) = mean(sample(nsamps,data));
   end
   
   % find out how often the runs are within the
   % specified confidence interval
   for k=1:length(conf)
     alphas = [(1-conf(k))/2., 1 - (1-conf(k))/2];
     foo = percentile(z,alphas);
     inside = foo(1) < 0 & foo(2) > 0;
     res(runs,k) = inside;
  end
end
for k=1:length(conf)
  fracinside(k) = count(res(:,k)==1)/nruns;
end
