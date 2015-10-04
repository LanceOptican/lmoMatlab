function sepmatrix(data,varargin)
% SEPMATRIX --- splits a matrix by columns
%
% sepmatrix data name1 name2 name3 ...
% pulls out the columns of a matrix into vectors
% each with the given name.

% (c) 1998-9 by Daniel T. Kaplan, All Rights Reserved
% Version 1.0

[r,c] = evalin('caller', sprintf('size(%s)',data));;

if c ~= length(varargin)
   error('sepmatrix: must provide the same number of names as columns in the data matrix.');
end

for k=1:length(varargin)
   str = sprintf('%s =  %s(:,%d);', varargin{k}, data,k);
   evalin('caller', str);
end

