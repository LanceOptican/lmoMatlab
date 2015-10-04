% ix = findNotNaNs(x)
% returns index into x where there are not NaNs
% so, [nan 1 2 nan 4 5] returns [2, 3; 5, 6]
% if there are only NaNs in x, returns []
%
% 17dec2014 LMO create
function ix = findNotNaNs(x)

lo = 1;
hi = numel(x);
ix = [];

while(1)
    klo = find(~isnan(x(lo:hi)));
    if isempty(klo)
        break
    else
        klo = (lo-1) + klo(1);
    end
    
    khi = find(isnan(x(klo:hi)));
    if isempty(khi)
        khi = hi;
    else
        khi = (klo-1) + khi(1) - 1;
    end

    if isempty(ix)
        ix = [klo, khi];
    else
        ix = [ix; [klo, khi]];
    end
    lo = khi + 1;

    if lo >= hi
        break
    end
end