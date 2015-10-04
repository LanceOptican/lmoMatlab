function [peaks] = peakfinderv(x)
% return peaks of a function (local maxima)
% valleys(:, 1) = index
% valleys(:, 2) = values
%
dx = diff(x);   % x(n) - x(n-1)
peaks = [];
n=0;
i=1;
len=length(dx);
% thresh = 0.01;
asc = 0;
while(i < len)
    while dx(i) > 0                                   % step along while slope is greater than 0
        asc = 1;
        if i < len
            i=i+1;
        else
            break
        end
    end
    if i == len
        break
    end

    % if we are here, we are no longer rising
    if (asc)
        n=n+1;                                                         %Increment array for next valley
        peaks(n,1)=i;                                              %Saving index into array
        peaks(n,2)=x(i);                                      %Saving magnitude into array
    end

    while dx(i) <= 0                                       
        asc = 0;
        if i < len
            i=i+1;
        else
            break
        end
    end
end
