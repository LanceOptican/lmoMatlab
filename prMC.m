function prMC(title, tbl)
% print multicompare table
[n, foo] = size(tbl);
disp(['Multcompare ' title ': '])
for i = 1:n
    if (tbl(i, 3) * tbl(i, 5) > 0)
        str = 'P < 0.05 *';
    else
        str = 'P > 0.05';
    end
    disp(sprintf('diff %d - %d = %5.4f +/- %5.4f %s', tbl(i, 1), tbl(i, 2), tbl(i, 4), tbl(i,4) - tbl(i,3), str));
end