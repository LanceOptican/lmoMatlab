% add error bars
% inputs:
% x = x-values for data points
% y = data points (nr x numGroup)
% err = 3-D array. Each row is a point, 1st col is low error, 2nd col is
% high error, 3rd col is group number
% colr is a color spec, e.g., 'r'
% wd = width of bar, e.g., 0.05 of x spacing
function h = errbars(X, Y, Err, colr, wd)

hbar = get(gca, 'children');   % get bar handles

n = numel(X);
dx = wd * (X(2) - X(1));
ng = size(Y, 2);
% barwidth = get(hbar(1), 'barwidth');
% groupwidth = 0.685 * barwidth;
% barRng = linspace(-1, 1, ng) * groupwidth;
if ng == 1
    barRng = 0;
else
    barRng = linspace(-1, 1, ng);
end
h = [];
for g = 1:ng  % for each bar in group
    y = Y(:, g);
    err = Err(:, :, g);
    x = X + barRng(g);
    for k = 1:n
        h = [h, plot([x(k), x(k)], y(k) + err(k, :), colr)];
        yl = y(k) + err(k, 1);
        h = [h, plot(x(k) + [-dx, dx], [yl, yl], colr)];
        yu = y(k) + err(k, 2);
        h = [h, plot(x(k) + [-dx, dx], [yu, yu], colr)];
    end
end
