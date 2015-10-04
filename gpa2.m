classsize = 100;
standard = [.10 1; .40 2; .35 3; .15 4];
expectednum = classsize*standard(:,1);
% This give the expected number of grades of each
% type, again in the ascending order of codes.
z = starttally;
for trials = 1:1000
   % generate a simulated class
   simclass = sample(classsize, standard);
   % compute the observed number of grades of
   % each type
   observednum = multiples(simclass, standard(:,2));
   teststat = sum( abs( observednum - expectednum ) );
   tally teststat z;
end
