% fitexp: fit main sequence peak vel vs. amp
% fit one exponential of form
%   v = P(1) * (1 - exp(-(a - P(2))/P(3)))
% if a < 0, reverses everyhing, computes, restores
% input:
%   P0 is the initial parameter guess:
%       P(1) = Asymptote,
%       P(2) = Position offset,
%       P(3) = Angle Constant.
%   a is amplitude
%   v is peak velocity
%   eFlag = eval only flag, so yfit is evaluated at [a(1):a(end)] with P0.
%   lblFlag = add labels for P
% output:
%   P is fitted parameter vector
%   [afit, vfit] is the fitted function.
%   Rsquare = explained variation in data
%   adjRsquare = Rsquare adjusted for number of parameters
%   ht = text handle
%
% 5dec2014  LM Optican    create
%
function [P, afit, vfit, Rsquared, adjRsquared, ht] = fitMainSeqExp(P0, a, v, eFlag, lblFlag)

% initial guess
if isempty(P0)
    P0 = [100, 1, 10];
end

if ~eFlag
    [P,fval,exitflag,output] = fminsearch(@(P) errfunc(P, a, v), P0, optimset('TolX',1e-12, 'TolFun', 1e-12, 'MaxIter', 1e3, 'MaxFunEvals', 1e5));
else
    P = P0;
end

% divide up range for output fit
nPoints = 100;
lo = min(a);
hi = max(a);
afit = lo + ((0:nPoints)/nPoints) * (hi - lo);
vfit = fitfunc(afit, P);

% get R-square value
vhat = fitfunc(a, P);
[Rsquared, adjRsquared] = Rsquares(v, vhat, numel(P));

if lblFlag
    ax = axis;
    ty = ax(3) + 0.05 * (ax(4) - ax(3));
    tx = (hi + lo) / 2;
    ht = text(tx, ty, sprintf('V_p = %5.1f * (1 - exp(-(|A| - %5.1f)/%5.1f))\nR^2 = %5.3f, aR^2 = %5.3f', ...
        P(1), P(2), P(3), Rsquared, adjRsquared));
    set(ht, 'horizontalalignment', 'center', 'verticalalignment', 'bottom');
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HELPER FUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute error
function err = errfunc(P, a, v)
% add constraints by creating forbidden region
if ((P(1) < 0) || P(1) > 2000 ||(abs(P(2)) > 3) || (P(3) < 0))
    err = 1e10;
else
    err = v - fitfunc(a, P);
    err = err * err';
end
    
% compute function
function v = fitfunc(a, P)

a = abs(a);
v = zeros(size(a));
k = find(a >= P(2));
v(k) = P(1) * (1 - exp(-(a(k) - P(2))/P(3)));


