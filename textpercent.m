% put text on figure at % of range,
% and allow for varagin to be text properties
function h = textpercent(px, py, str, varargin)

ax = axis;

x0 = ax(1) + (px/100) * (ax(2) - ax(1));
y0 = ax(3) + (py/100) * (ax(4) - ax(3));

h = text(x0, y0, str);

n = length(varargin);
if n
    for k = 1:2:n
    set(h, varargin{k}, varargin{k+1});
    end
end
