function res = exclude( data, inds )
% EXCLUDE --- exclude data from a vector
% exclude( data, inds )
% leave out of <data> the points at the indicated indices
% e.g., exclude(data, 5) to leave out the fifth point
%       exclude( data, [2 10]} to leave out the second and tenth
% if data is a matrix, this assumes that each row is one data point

% (c) 1998-9 by Daniel T. Kaplan, All Rights Reserved
% Version 1.0

indices = 1:(length(data));

for k=1:length(inds)
   indices = indices(find(indices ~= inds(k)));
end

[r,c] = size(data);

if c == 1 | r == 1
   res = data(indices);
else
   res = data(indices,:);
end

   
