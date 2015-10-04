function res = sumsqrdev(vec1,vec2)
% SUMSQRDEV(vec1, vec2) 
% computes the sum of squared differences between two vectors

vec1 = makerow(vec1);
vec2 = makerow(vec2);
[r1,c1] = size(vec1);
[r2,c2] = size(vec2);
if r1 ~= 1 | r2 ~= 1
   error( 'sumsqrdev: arguments are not vectors');
end

if (r1 ~= r2 )
   error( 'sumsqrdev: the two vectors are not the same length.');
end

res = sum( ( vec1-vec2).^2  );