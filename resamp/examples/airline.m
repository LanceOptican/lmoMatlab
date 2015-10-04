% delays in minutes of Northworst flights before and after a
% threat made by the machinists' union

beforethreat = [10 12 -1 82 7 -3 4 196 18];
afterthreat = [-2 71 290 4 102 78 6 125];

NWdiff = mean(afterthreat) - mean(beforethreat);

nullarrivals = concat( beforethreat, afterthreat);

z = starttally;
for trials = 1:1000
   beforet = sample(length(beforethreat), nullarrivals);
   aftert  = sample(length(afterthreat), nullarrivals);
   teststat = mean( aftert) - mean(beforet);
   tally teststat z;
end

histogram(z,'Difference of means under Null Hyp.');
hold on;
plot(48.1, 0:.001:.012, '*');
xlabel('Diff in mean delays (minutes): after threat - before threat');
hold off;

display('p-value (one-tailed)');
count(z>NWdiff)/length(z)

display('p-value (two-tailed)');
m = mean(z);
if( m < NWdiff )
   rightextreme = NWdiff;
   leftextreme = m - (NWdiff - m);
else
   leftextreme = NWdiff;
   rightextreme = m + (m - NWdiff);
end

count( z< leftextreme | z > rightextreme)/length(z)



