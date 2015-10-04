function res = less4500(data)
% less4500(data)
% give the fraction of bootstrap realizations where the
% sum of 4 randomly selected points is less than 4500.
% This is for the light-bulb example

z = starttally;
Ntrials = 1000;
for trial = 1:Ntrials
   z = [z; sum(sample(4,data))];
end
res = count(z<4500)/Ntrials;
