function [s k] = cellsqueeze(c)
m = 0;
k = [];
s = [];
for i = 1:length(c)
    if (~isempty(c{i}))
        m = m + 1;
        s{m} = c{i};
        k = [k i];
    end
end