% nanremove - function to remove nans
function x = nanremove(x)
x(isnan(x)) = [];
