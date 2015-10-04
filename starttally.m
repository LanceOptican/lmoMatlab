function res = starttally
% STARTTALLY: initialize keeping tally in Resampling Statistics
% Use this before a loop to create a new variable for keeping
% track of results of calculations
% For example:
% z = starttally;  % This isn't in the Resampling Statistics examples
% for k=1:100
%    a = count( 1 == generate(urn));
%    tally a z;
% end
% z/length(z)
%
% MATLAB experts:
% It's much faster to do this as
% z = [];
% for k=1:100
%    a = count( 1 == generate(urn));
%    z = [z; a];
% end
% z/length(z);
% 
% or, even better,
% Ntrials = 100;
% z = zeros(Ntrials,1);
% for k=1:Ntrials
%    z(k) = count( 1 == generate(urn));
% end

% (c) 1998-9 by Daniel T. Kaplan, All Rights Reserved
% Version 1.0

res = [];


