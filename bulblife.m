% total lifetime of bulbs in a package of 4
data = [2103 2786 2543 1987 7 2380 3102 2452 3453 2543];

z = starttally;
for trials=1:1000 % see caution warning in text
   b = sample(4,data);
   totallife = sum(b);
   tally totallife z;
end
percentile(z,.01)

   