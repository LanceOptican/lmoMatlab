function mid = binarysearch_testend(A, v)
%
% binary search for value in list A
% use non-recursive algorithm, test only at end
% for use when test is costly
%
N = length(A);
lo = 1;
hi = N;
while(lo < hi)
    mid = fix((lo + hi)/2);
    if (A(mid) < v)
        lo = mid + 1;
    else
        hi = mid;
    end
end
if (lo < (N+1) & (A(lo) == v))
    mid = lo;
else
    mid = [];
end

    