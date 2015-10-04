function levels = actualconf
% actualconf
% using a simulation, estimate the actual confidence
% level of a bootstrapped confidence level of the mean.
ntrials=1000;
nsamps = [3 5 10 20 50 100];
conf = [.95 .90 .60];
% levels will 
levels = zeros(length(nsamps),length(conf));
for k = 1:length(nsamps)
   foo = howmany( nsamps(k), conf, ntrials);
   levels(k,:) = foo;
end

save confresults.dat levels -ascii