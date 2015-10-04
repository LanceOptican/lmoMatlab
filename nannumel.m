% return number of elements that are not NaNs
function n = nannumel(x)
n = numel(x(~isnan(x)));
