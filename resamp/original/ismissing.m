function res = ismissing(data)
% ISMISSING(data) returns a 1 for each missing datavalue
%  and a 0 for non-missing values

% (c) 1998-9 by Daniel T. Kaplan, All Rights Reserved
res = isnan(data);