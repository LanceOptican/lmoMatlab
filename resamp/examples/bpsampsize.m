% we'll try several study sizes
trysizes = [20; 30; 40; 50];
results = starttally;

% loop over each of the study sizes
for studysize = 1:length(trysizes)
  % for each study size, carry out many simulations
  z = starttally;
  for trials = 1:100
     pvalue = bpstudy(trysizes(studysize));
     tally pvalue z;  
     [trysizes(studysize), pvalue] 
     % print out intermediate results
     % so that we can see what's going on     
  end

  % count what fraction of studies gave 
  % a sufficiently low p-value
  success = proportion(z <= 0.025);
  tally success results;
end

