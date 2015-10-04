function res = bppower(studysize)
% bppower(studysize)
% computes the power of a study at a given study size
% uses the program <bpstudy> that does a simulation
% of a study of the given size.  The parameters
% of the study are in <bpstudy>.

% carry out many simulations
z = starttally;
for trials = 1:100
   pvalue = bpstudy(studysize);
   tally pvalue z;  
   pvalue
   % print out intermediate results
   % so that we can see what's going on     
end

% count what fraction of studies gave 
% a sufficiently low p-value
res = proportion(z <= 0.025);
 