function res = dedup(data)
% DEDUP ( data ) -- gives unique values in a vector
%
% gives a vector of the unique values in <data>, each listed once.
% see MULTIPLES.

% (c) 1998-9 by Daniel T. Kaplan, All Rights Reserved
% Version 1.0
[cnd,res] = multiples(data);
