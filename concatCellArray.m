% concatCellArray - concatenate all cells into one array
function a = concatCellArray(c)

a = [];
for k = 1:numel(c)
    ca = c{k};
    n = numel(ca);
    ca = reshape(ca, n, 1);
    a = [a; ca];
end