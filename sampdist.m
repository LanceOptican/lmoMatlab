dist = normal(0,1);
res = starttally;
for sampsize = [25 100 400] % three different sample sizes
  tmp = confintervals( 0, lambda('mean(sample(sampsize,dist))'),.68)'
  tally  tmp res;
end
res
