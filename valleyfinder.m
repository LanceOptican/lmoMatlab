function [valleys] = valleyfinder(x)
% return valleys of a function (local minima)
% valleys(:, 1) = index
% valleys(:, 2) = values
%
dx = diff(x);   % x(n) - x(n-1)
valleys = [];
n=0;
i=1;
len=length(dx);
% thresh = 0.01;
desc = 0;
while(i < len)
    while dx(i) < 0                                   % step along while slope is less than 0
        desc = 1;
        if i < len
            i=i+1;
        else
            break
        end
    end
    if i == len
        break
    end

    % if we are here, we are no longer declining
    if (desc)
        n=n+1;                                                         %Increment array for next valley
        valleys(n,1)=i;                                              %Saving index into array
        valleys(n,2)=x(i);                                      %Saving magnitude into array
    end

    while dx(i) >= 0                                       %decreasing counter
        desc = 0;
        if i < len
            i=i+1;
        else
            break
        end
    end
end

% if no valleys, pick the min
if (length(valleys) == 0)
   [valleys(1,2), valleys(1,1)] = min(x); 
end
