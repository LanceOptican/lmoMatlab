function [len, vals] = runs(data)
% RUNS --- finds runs (sequences of repeated values)
% runs(data) 
% gives the lengths of runs in the data set.
%
% [len, vals] = runs(data) 
% gives both the length of the runs and the value of that run.


% (c) 1998-9 by Daniel T. Kaplan, All Rights Reserved
% Version 1.0

% put the data into row format
[r,c] = size(data);
if r~=1 & c~=1
  error('runs: input must be a vector.');
end

if c==1
  data = data';
end

% find the starts of the runs
inds = [1, (1+find(0 ~= diff(data)))];

len = diff([inds,length(data)+1]);
vals = data(inds);
