% test denoiseSig

dt = 0.001;
t = ([1:3943]' - 1)* dt;

x = sin(2 * pi * 3.5 * t) + 0.5 * cos(2 * pi * 40.3 * t) + randn(size(t))/10;

nLev = 7;
clrs = colormap(hsv(nLev+1));
figure(1)
clf
subplot(2, 1, 1);
plot(t, x, 'color', clrs(1, :), 'linewidth', 1);
hold on
lbls = [];
lbls{1} = 'data';


for level = 1:nLev
    y = denoiseSig(x, level);
    ax(1) = subplot(2, 1, 1);
    plot(t, y, 'color', clrs(level+1,:));
    hold on
    lbls{level+1} = sprintf('%d', level);
    
    ax(2) = subplot(2, 1, 2);
    r = x - y;
    plot(t, r, 'color', clrs(level+1,:));
    hold on
end
legend(ax(1), lbls);
linkaxes(ax);
