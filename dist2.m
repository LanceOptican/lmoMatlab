location = [78 145 132 94 67 44 93 78 120 34 78 53 119 95];

where = [];
dists = [];
means = [];

for here = 50:5:150
   where = [where;here];
   temp = [];
   for trials = 1:500
     newloc = sample(length(location),location);
     temp = [temp; median(abs(here-newloc))];
   end
   foo = percentile(temp,[.1, .9]);
   dists = [dists; foo'];
   means = [means; mean(foo)];
end


plot(where, means, 'x');
hold on;
plot(where, dists(:,1), 'o');
plot(where, dists(:,2), 'o');
xlabel('location of clinic');
ylabel('10th, 90th, and mean of the trial median distances.');