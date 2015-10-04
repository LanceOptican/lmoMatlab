% Our prior probabilities
prior = [5 .25; 5 .30; 5 .35; 5 .40; 5 .45; 75 .50 ];

% Keep track of what his true shooting rate is and the
% resulting score
scorerecord = starttally;
raterecord  = starttally;

for trials = 1:5000
  rate = sample(1,prior);
  % how well is Bird shooting
  bird = [(1-rate) 0; rate 1];
  baskets = count(sample(57, bird)==1);
  tally rate raterecord;
  tally baskets scorerecord;
end

subplot(2,1,1);
hist(raterecord,100);
title('Prior distribution (sampled)');
subplot(2,1,2);
hist( raterecord(find(scorerecord==20)), 100);
title('Posterior distribution (sampled)');
