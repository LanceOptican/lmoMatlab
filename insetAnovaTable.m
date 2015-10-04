% put a table in a figure
function ht = insetAnovaTable(tbl, xpc, ypc, deltax, deltay, fntsz)
cnames = tbl(1, [1:3, 5:end]);
rnames = tbl(2:end, 1);
data = tbl(2:5, [2:3, 5:end]);
x0 = xpc;
y0 = ypc;
nht = 0;
for k = 1:length(cnames)
    nht = nht+1;
    ht(nht) = textpercent(x0, y0, cnames{k});
    x0 = x0 + deltax;
end

for k = 1:length(rnames)
    x0 = xpc;
    y0 = y0 - deltay;
    nht = nht + 1;
    ht(nht) = textpercent(x0, y0, rnames{k});
    
    for j = 1:size(data,2)
        
        switch(j)
            case 1
                fmt = '%10.1f';
            case 2
                fmt = '%2d';
            case 3
                fmt = '%10.1f';
            case 4
                fmt = '%4.2f';
            case 5
                fmt = '%5.4f';
        end
        
        nht = nht + 1;
        x0 = x0 + deltax;
        ht(nht) = textpercent(x0, y0, sprintf(fmt, data{k, j}));
    end
end

set(ht, 'fontsize', fntsz, 'horizontalalignment', 'right');
