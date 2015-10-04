function res = tagsort(data)
% TAGSORT(data)
% Returns an index 'key' to data so that indexing data
% with the key will give a sorted version of data
% This is useful for sorting other vectors so that the
% elements of the other vectors stay in corresponding entries.
%
% Example:
% a = [6  5  4  2  9  3  2  1];
% b = [10 9 11  7  6  2 12 19];
% key = tagsort(a);
% newa = a(key);
% newb = b(key);
% now newa is sorted in ascending order while newb is
% rearranged to keep its entries paired with those in a
% (that is, 10 is matched with 6, 9 with 5, and so on.
%
% to sort in descending order, use
% tagsort(-data)

% Version 1.0

[ndata, res] = sort(data);

