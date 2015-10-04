function [frac, pvalue] = gpadist( classsize )
% [frac,pvalue] = gpadist (classsize )
% gives 
% 1) the fraction of times when the glass gpa
% will be outside of the 2.05 to 3.05 interval specified
% by the Attorney General
% 2) the p-value when the actual class GPA is 3.10
% assuming that students are picked randomly from the 
% legislatively mandated distribution.

% each grade is represented by its grade point: e.g., A == 4.

% the professor's class size
classsize = 10;

% the legislatively mandated distribution of grades
standard = [.15 4; .35 3; .40 2; .1 1];
z = starttally;
Ntrials = 1000;
for trials = 1:Ntrials
   class = sample(classsize, standard);
   teststat = mean(class);
   tally teststat z;
end
frac = count( z > 3.05 | z < 2.05)/length(z);
pvalue = count( z>=3.10 ) / length(z);
hist(z,50);
title('Distribution of class grades')
xlabel('Class GPA')
ylabel('Frequency')

