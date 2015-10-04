% test errbar_groups

nBars = 3;
nGroups = 4;


y = zeros(nBars, nGroups);
errL = zeros(nBars, nGroups);
errU = zeros(nBars, nGroups);
for nB = 1:nBars
    for nG = 1:nGroups
        y(nB, nG) = sqrt(nB);
        errL(nB, nG) = 0.1;
        errU(nB, nG) = 0.6;
    end
end
errorbar_groups(y, errL, errU)
