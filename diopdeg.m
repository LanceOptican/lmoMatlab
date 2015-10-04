% convert diopters/degrees of visual angle
% where the null argument is filled in for output
% [diopters, degrees] = diopdeg(diopters, degrees)
%
function [diopters, degrees] = diopdeg(diopters, degrees)
if isempty(degrees)
    degrees = atan(diopters/100) * 180/pi;
else
    diopters = 100*tan(degrees * pi/180);
end