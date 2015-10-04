years  = [1965 1971 1974 1977 1978 1979 1980];
storks = [1920 1700 1090  990 1030  995  930];
babies = [1.04 0.78 0.62 0.58 0.57 0.58 0.62];

Ntrials = 1000;
Ndata   = length(years);
z = starttally;
for trials = 1:Ntrials
   inds = sample( Ndata, 1:Ndata );
   stks = storks(inds);
   babs = babies(inds);
   r = corr(stks, babs);
   rsq = r.*r;
   tally rsq z;
end

hist(z,100);
title('r^2 for storks and babies')
xlabel('r^2')
ylabel('frequency');
disp('The 95 percent confidence interval is:');
[percentile(z,.025), percentile(z,.975)]

   