%% legendShrinkLineLength
%
%% egendShrinkLineLength(objleg, shrinkFac)
%
% Purpose:
% shrink the line length in a legend
%
%
%% INPUT:
% objleg = the second output of the legend() command,
%       as in [hleg,objleg,outleg, strleg] = legend()
% shrinkFac = the fraction of the old length to keep; default value is 0.5;
%
%% OUTPUT:
% none
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright 2015 by U.S. Government. Non-commercial
% right of use is freely granted.
%
% 26may2015 Lance M. Optican Created
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function legendShrinkLineLength(objleg, shrinkFac)
if nargin < 2
    shrinkFac = 0.5;
end
% first, shrink lines by moving in from left
for k = 1:length(objleg)
    leg = objleg(k);
    if strcmp(get(leg, 'type'), 'line')
        Xdata = get(leg, 'Xdata');
        x = [Xdata(end) - (Xdata(end) - Xdata(1))*shrinkFac, Xdata(end)];
        set(leg, 'Xdata', x);
    end
end

% since can't find handle for box, for now just turn it off
legend boxoff

