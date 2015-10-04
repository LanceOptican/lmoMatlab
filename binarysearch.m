function mid = binarysearch(A, v)
%
% binary search for value in list A
% use iterative algorithm
%
N = length(A);
lo = 1;
hi = N;
while(lo <= hi)
    mid = fix((lo + hi)/2);
    if (A(mid) > v)
        hi = mid - 1;
    elseif (A(mid) < v)
        lo = mid + 1;
    else
        return
    end
end
mid = [];
