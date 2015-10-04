years  = [1965 1971 1974 1977 1978 1979 1980];
storks = [1920 1700 1090  990 1030  995  930];
babies = [1.04 0.78 0.62 0.58 0.57 0.58 0.62];

actualvalue = (corr(storks,babies)).^2;
Ntrials = 1000;
Ndata   = length(years);
z = starttally;
for trials = 1:Ntrials
   stks = sample( Ndata, storks );
   babs = sample( Ndata, babies);
   r = corr(stks, babs);
   rsq = r.*r;
   tally rsq z;
end

disp('The one-tailed p-value is');
count( z >= actualvalue)/Ntrials

   