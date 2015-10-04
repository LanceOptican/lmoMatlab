beforethreat = [10 12 -1 82 7 -3 4 196 18];
afterthreat  = [-2 71 290 4 102 78 6 125];

disp('value of the test statistic:')
ourval = proportion(afterthreat>15) - proportion(beforethreat>15)
nullarrivals = concat(beforethreat, afterthreat);
z = starttally;
for trials = 1:1000
   beforeinds = 1:length(beforethreat);
   newdata = shuffle(nullarrivals);
   beforet = newdata(beforeinds);
   aftert  = exclude(newdata, beforeinds);
   teststat = proportion(aftert>15) - proportion(beforet>15);
   tally teststat z;
end

histogram(z);
hold on;
plot(ourval, 0:.001:.02, '*');
hold off