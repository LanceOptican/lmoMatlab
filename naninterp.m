% naninterp - from E. Rodriguez, Mathworks Exchange, 2005
function X = naninterp(X, method)
% Interpolate over NaNs
% See INTERP1 for more info
if nargin < 2
    method = 'pchip';
end
X(isnan(X)) = interp1(find(~isnan(X)), X(~isnan(X)), find(isnan(X)), method);
